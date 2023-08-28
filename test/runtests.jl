#!/usr/bin/env julia
using ThesaurusDist
using Test

@testset "Utilities" begin
    @test ThesaurusDist.nrm("Potato") == ThesaurusDist.nrm("pOTATO")
    @test ThesaurusDist.nrm("Potato") != ThesaurusDist.nrm("Tomato")
    @test ThesaurusDist.cmp("Potato", "pOTATO")
    @test !ThesaurusDist.cmp("Potato", "tOMATO")
    @test ThesaurusDist.cin("Potato", ["pOTATO", "Tomato"])
    @test !ThesaurusDist.cin("Potato", ["tOMATO", "Tomato"])
end

@testset "Synonyms" begin
    @test !isempty(ThesaurusDist.synonyms("Potato"))
    @test ThesaurusDist.synonyms("POTATO") == ThesaurusDist.synonyms("potato")
    @test ThesaurusDist.synonyms("tomato") == ThesaurusDist.synonyms("tomato")
    @test length(ThesaurusDist.synonyms("Potato")) == 7
    @test length(ThesaurusDist.synonyms("tOmaTo")) == 3
    @test isempty(ThesaurusDist.synonyms("Adirondack"))
end

@testset "Dist" begin
    @test isnothing(ThesaurusDist.dist("potato", "tomato"))
    @test ismissing(ThesaurusDist.dist("potato", "adirondack"))
    queue = [("potato", 0)]
    blocklist = String[]
    while !isempty(queue)
        (target, idx) = popfirst!(queue)
        push!(blocklist, target)
        @test ThesaurusDist.dist("potato", target) == idx
        targets = filter(x -> !(x in first.(queue) || x in blocklist), ThesaurusDist.synonyms(target))
        append!(queue, map(x -> (x, idx+1), filter(x -> haskey(ThesaurusDist.data, x), targets)))
        idx>4 && break
    end
    @test length(ThesaurusDist.wordspace("potato", "gain")) == 451
    @test length(ThesaurusDist.wordspace("potato", "tater")) == 8
    dm = ThesaurusDist.distmetric("potato", "tater")
    @test size(dm[1]) == (8, 8)
    @test dm[1] == dm[1]'
    @test length(dm[2]) == 8
    @test dm[2] == ThesaurusDist.wordspace("potato", "tater")
    dm = ThesaurusDist.distmetric("potato", "sprout")
    @test dm[1] isa Matrix
    @test size(dm[1]) == (length(dm[2]), 16)
end
