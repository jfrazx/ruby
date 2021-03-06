RAGEL = ragel

.SUFFIXES: .rl

.rl.c:
	$(RAGEL) -G2 $<
	$(BASERUBY) -pli -e '$$_.sub!(/[ \t]+$$/, "")' \
	-e '$$_.sub!(/^static const int (JSON_.*=.*);$$/, "enum {\\1};")' \
	-e '$$_.sub!(/^(static const char) (_JSON(?:_\w+)?_nfa_\w+)(?=\[\] =)/, "\\1 MAYBE_UNUSED(\\2)")' \
	-e '$$_.sub!(/0 <= ([\( ]+\*[\( ]*p\)+) && \1 <= 31/, "0 <= (signed char)(*(p)) && (*(p)) <= 31")' \
	-e '$$_ = "/* This file is automatically generated from parser.rl by using ragel */\n" + $$_ if $$. == 1' $@

parser.c:
