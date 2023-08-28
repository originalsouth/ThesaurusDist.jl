using Unicode

struct Word
	word::String
	synonyms::Vector{String}
	wtype::String
end
word(w::Word) = w.word
synonyms(w::Word) = w.synonyms
wtype(w::Word) = w.wtype

nrm(str::String) = Unicode.normalize(str; casefold = true)
cmp(str1::String, str2::String) = .==(nrm.((str1, str2))...)
cin(str::String, strs::Vector{String}) = any(cmp.(Ref(str), strs))
