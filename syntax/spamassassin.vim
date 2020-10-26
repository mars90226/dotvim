" Vim syntax file
" Language: Spamassassin configuration file
" Maintainer: Adam Katz <scriptsATkhopiscom>
" Website: http://khopis.com/scripts
" Version: 3.3+20110621
" License: Your choice of Creative Commons Share-alike 2.0 or Apache License 2.0
" Copyright: (c) 2009+ by Adam Katz

" Save this file to ~/.vim/syntax/spamassassin.vim
" and add the following to your ~/.vim/filetype.vim:
" 
"     augroup filedetect
"         au BufRead,BufNewFile user_prefs,*.cf,*.pre setfiletype spamassassin
"     augroup END

" This contains EVERYTHING in the Mail::SpamAssassin:Conf man page,
" including all plugins that ship with SpamAssassin and even a few others.
" Only a few eval:foobar() functions are supported (there are too many).

if version < 600
  echo "Vim 6 or later is needed for this syntax file"
  finish " ... note that 'finish' isn't vim-5 compatible...
endif

if exists("b:current_syntax")
  finish
endif

" Regular expression matching from perl (also pulls @perlInterpSlash)
syn include @perlInterpMatch	syntax/perl.vim

syntax sync clear
if exists('+synmaxcol')
  set synmaxcol=8000 " should be safe; reduce if struggling on super-long lines
endif
if exists('+minlines')
  syntax sync minlines=0
elseif exists('+g:vim_minlines')
  syntax sync g:vim_minlines=0
endif
" SA doesn't have multi-line items (except if/endif, which we don't track)
if exists('+maxlines')
  syntax sync maxlines=2 " this should provide a significant speed boost
elseif exists('+g:vim_maxlines')
  syntax sync g:vim_minlines=2
endif


"""""""""""""
" Generic bits, largely inherited or tweaked from perl

syn match saMatchParent	"\%(\<[m!]\([[:punct:]]\)\|\s\zs\(\/\)\).*\1\2[cgimosx]*\%(\s\|$\)\@=" contains=saMatch,saComment contained nextgroup=saComment,saError skipwhite

" caters for matching by grouping:  m{} and m[] (and the !/ variant)
syn match saMatchParent	"\<[m!]\%([[{]\).*[]}][cgimosx]*\%(\s\|$\)\@=" contains=saMatch contained nextgroup=saComment,saError skipwhite
syn region saMatch	matchgroup=saMatchStartEnd start=+[m!]{+ end=+}[cgimosx]*\%(\s\|$\)+ contains=@perlInterpMatch oneline contained
syn region saMatch	matchgroup=saMatchStartEnd start=+[m!]\[+ end=+\][cgimosx]*\%(\s\|$\)+ contains=@perlInterpMatch oneline contained

" A special case for m!!x which allows for comments and extra whitespace
" (Linebreaks and comments in regexps are buggy, probably(?) unsupported in SA)
syn region saMatch	matchgroup=saMatchStartEnd start=+[m!]!+ end=+![cgimosx]*\%(\s\|$\)+ contains=@perlInterpSlash,saComment oneline contained

" match // and !?? and m?? for any ? matching punctuation
syn region saMatch	matchgroup=saMatchStartEnd start=+[m!]\z([[:punct:]]\)+ end=+\z1[cgimosx]*\%(\s\|$\)+ contains=@perlInterpSlash oneline contained

syn match saWrongMatchOp	"[~]=" containedin=ALL

syn region  saQuote	start=+'+ end=+'+ skip=+\\'+ oneline contains=@Spell
syn region  saQuote	start=+"+ end=+"+ skip=+\\"+ oneline contains=@Spell
"syn region  saQuote	start=+"+ end=+"+ skip=+\\"+ oneline contains=@Spell,@saTemplateTags

syn keyword saTodo	TODO TBD FIXME XXX BUG contained
" safe because SA has the same bug; regexps must have their hashes escaped.
syn match   saComment	"\%(\\\)\@<!#.*$" contains=saTodo,saURL,@Spell

syn match saParens "[()]"
syn match saNumber "[([:space:]]\@<=-\?\d\{1,90\}\>\%(\.\d\{1,90\}\)\?\>"
syn match saNumber "[-+*/.,<=>!~[:space:]]\@<=-\?\d\{1,90\}\%(\.\d\{1,90\}\)\?\%(\s\|[-+*/.,<=>!~]\|$\)\@=" contained
syn match saIPaddress "\s\@<=\%([012]\?\d\?\d\.\)\{1,3\}\%([012]\?\d\?\d\%(\/[0123]\?\d\)\?\)\?\%(\s\|$\)"
syn match saURL "\v\%(f|ht)tps?://[-A-Za-z0-9_.:@/#%,;~?+=&]{4,}" contains=@NoSpell transparent "contained
"syn match saPath "\v[:[:space:]]/[-A-Za-z0-9_.:@/%,;~+=&]+[^\\]/\%([msixpgc]+\>)\@!" transparent
" previously also needed this workaround:
"syn match saPath "\v[:[:space:]]\zs/\%(etc|usr|tmp|var|dev|bin|home|mnt|opt|root)/[-A-Za-z0-9_.:@/%,;~+=&]+" transparent
syn match saEmail "\v\c[a-z0-9._%+*-]+\@[a-z0-9.*-]+\.[a-z*]{2,4}%([^a-z*]|$)\@=" contains=saEmailGlob
syn match saEmailGlob "\*" contained

syn match saString	"\S.*$"	contains=saComment contained
syn match saError	"\S.*$"	contains=saComment contained
syn match saErrWord	"\S\+"	contains=saComment contained


"""""""""""""
" SpamAssassin-specific bits

syn match saRuleStart "^" nextgroup=saTR,@saRule,saComment skipwhite

syn keyword saTR lang contained nextgroup=saLangKeys,saLangCountry,saErrWord skipwhite
  syn keyword saLangKeys af am ar be bg bs ca cs cy da de el en   contained nextgroup=@saRule skipwhite
  syn keyword saLangKeys eo es et eu fa fi fr fy ga gd he hi hr   contained nextgroup=@saRule skipwhite
  syn keyword saLangKeys hu hy id is it ja ka ko la lt lv mr ms   contained nextgroup=@saRule skipwhite
  syn keyword saLangKeys ne nl no pl pt qu rm ro ru sa sco sk     contained nextgroup=@saRule skipwhite
  syn keyword saLangKeys sl sq sr sv sw ta th tl tr uk vi yi      contained nextgroup=@saRule skipwhite
  syn match   saLangKeys "\<zh\>\%(\.big5\|\.gb2312\|[^.]\@=\)\>" contained nextgroup=@saRule skipwhite
  syn match   saLangCountry "\v%([a-z]{2}|sco|zh\.\w+)_[A-Z]{2}>" contained nextgroup=@saRule skipwhite

" These clusters can be added to by plugins.
syn cluster saKeyword contains=saLangKeys,saLocaleKeys
syn cluster saRule contains=saLists,saHeaderType,saNet,saBayes,saMisc,saPrivileged,saType,saDescribe,saReport,saAdmin,saAdminBayes,saAdminScores,saPreProc,saLocale
syn cluster saTemplateTags contains=saBaseTT
syn cluster saTFlags contains=saBaseTFlags
syn cluster saFunction contains=saBaseFunc

" a cluster of pretty-much identical regexps matching SA rule names
" (with different match names due to different nextgroups)
syn cluster saRuleNames contains=saHeaderRule,saDescRule,saBodyRule,saUriRule,saTFlagsRule,saMetaRule,saURIBLRule,saShortCircuitRule,saURIDetailRule
  syn match saPredicate "\<__\w\+\>" contained containedin=@saRuleNames
  syn match saTestRule "\<\%(__\)\?T_\w\+\>" contained containedin=@saRuleNames

syn keyword saLists blacklist_to blacklist_from unblacklist_from contained
syn keyword saLists whitelist_to whitelist_from unwhitelist_from whitelist_allows_relays contained
syn keyword saLists whitelist_from_rcvd def_whitelist_from_rcvd unwhitelist_from_rcvd contained
syn keyword saLists whitelist_auth def_whitelist_auth unwhitelist_auth whitelist_bounce_relays contained
syn keyword saLists more_spam_to all_spam_to whitelist_subject blacklist_subject contained

syn keyword saHeaderType clear_headers report_safe contained

syn keyword saHeaderType rewrite_header nextgroup=saHeaderRWName,saErrWord skipwhite contained
  syn keyword saHeaderRWName subject from to Subject From To contained nextgroup=saHeaderString skipwhite

syn keyword saHeaderType add_header nextgroup=saHeaderClause skipwhite contained
  syn match   saHeaderClause "\w\{3,4\}" contained contains=saHeaderClauseList,saErrWord nextgroup=saHeaderName skipwhite
      syn keyword saHeaderClauseList spam ham all Spam Ham All ALL contained
    syn match saHeaderName "\S\{1,60\}" contained nextgroup=saHeaderString skipwhite transparent
syn keyword saHeaderType remove_header nextgroup=saHeaderClauseR skipwhite contained
  syn match   saHeaderClauseR "\w\{3,4\}" contained contains=saHeaderClauseList,saErrWord nextgroup=saHeaderNameR skipwhite
    syn match saHeaderNameR "\S\{1,60\}" contained nextgroup=saError skipwhite transparent

syn match saHeaderString ".\+$" contained contains=@saTemplateTags
  syn match   saBaseTT "_\%(SCORE|\%(SP\|H\)AMMYTOKENS\)\%([0-9]\+\)_" contained
  syn match   saBaseTT "_\%(STARS\|\%(SUB\)\?TESTS\%(SCORES\)\?|HEADER\)\%(.\+\)_" contained
  syn keyword saBaseTT _YESNOCAPS_ _YESNO_ _REQD_ _VERSION_ _SUBVERSION_ _SCORE_ _HOSTNAME_ contained
  syn keyword saBaseTT _HOSTNAME_ _REMOTEHOSTNAME_ _REMOTEHOSTADDR_ _BAYES_ _TOKENSUMMARY_ contained
  syn keyword saBaseTT _BAYESTC_ _BAYESTCLEARNED_ _BAYESTCSPAMMY_ _BAYESTCHAMMY_ contained
  syn keyword saBaseTT _HAMMYTOKENS_ _SPAMMYTOKENS_ _DATE_ _STARS_ _RELAYSTRUSTED_ contained
  syn keyword saBaseTT _RELAYSUNTRUSTED_ _RELAYSINTERNAL_ _RELAYSEXTERNAL_ _LASTEXTERNALIP_ contained
  syn keyword saBaseTT _LASTEXTERNALRDNS_ _LASTEXTERNALHELO_ _AUTOLEARN_ _AUTOLEARNSCORE_ contained
  syn keyword saBaseTT _TESTS_ _TESTSCORES_ _SUBTESTS_ _DCCB_ _DCCR_ _PYZOR_ _RBL_ _LANGUAGES_ contained
  syn keyword saBaseTT _PREVIEW_ _REPORT_ _SUMMARY_ _CONTACTADDRESS_ _RELAYCOUNTRY_ contained

" more added by the TextCat plugin below in saLang, see also saTR for the 'lang' setting
syn keyword saLocale normalize_charset contained
syn keyword saLocale ok_locales  contained nextgroup=saLocaleWord skipwhite
  syn match saLocaleWord "\w\+\>" contained contains=saLocaleKeys,saErrWord nextgroup=saLocaleWord skipwhite
    syn keyword saLocaleKeys en ja ko ru th zh contained nextgroup=saLocaleKeys,saErrWord skipwhite

syn keyword saNet trusted_networks clear_trusted_networks internal_networks clear_internal_networks contained
syn keyword saNet msa_networks clear_msa_networks always_trust_envelope_sender skip_rbl_checks contained
syn keyword saNet dns_available dns_test_interval contained

syn keyword saBayes use_bayes use_bayes_rules bayes_auto_learn bayes_auto_learn_threshold_nonspam contained
syn keyword saBayes bayes_auto_learn_threshold_spam bayes_ignore_header bayes_ignore_from contained
syn keyword saBayes bayes_ignore_to bayes_min_ham_num bayes_min_spam_num contained
syn keyword saBayes bayes_learn_during_report bayes_sql_override_username bayes_use_hapaxes contained
syn keyword saBayes bayes_journal_max_size bayes_expiry_max_db_size contained
syn keyword saBayes bayes_auto_expire bayes_learn_to_journal contained

syn keyword saMisc required_score fold_headers contained
syn keyword saMisc lock_method contained nextgroup=saLockKeys skipwhite
  syn keyword saLockKeys nfssafe flock win32 contained nextgroup=saComment,saError skipwhite

syn keyword saPrivileged allow_user_rules contained
syn keyword saPrivileged redirector_pattern contained nextgroup=saMatchParent,saBodyMatch skipwhite

syn keyword saType score describe meta body rawbody full contained
syn keyword saType priority reuse tflags uri mimeheader contained

syn keyword saReport unsafe_report report contained nextgroup=saString skipwhite
syn keyword saReport report_safe_copy_headers envelope_sender_header report_charset contained
syn keyword saReport clear_report_template report_contact report_hostname contained
syn keyword saReport clear_unsafe_report_template contained

syn keyword saEval eval contained nextgroup=saHeaderEvalColon
  syn match saHeaderEvalColon ":" contained nextgroup=saFunctionCall
    syn match saFunctionCall "[^([:space:]]\+" contains=@saFunction nextgroup=saFunctionContent contained
        syn keyword saBaseFunc all check_rbl check_rbl_txt contained
        syn keyword saBaseFunc check_rbl_sub plugin check_test_plugin contained
        syn keyword saBaseFunc check_subject_in_whitelist check_subject_in_blacklist contained
      syn region saFunctionContent start=+(+ end=+)+ contains=saParens,saNumber,saFunctionString,saComment contained oneline
        syn region saFunctionString start=+'+ end=+'+ skip=+\\'+ contained oneline
        syn region saFunctionString start=+"+ end=+"+ skip=+\\"+ contained oneline

syn keyword saType mimeheader header contained nextgroup=saHeaderRule skipwhite
  syn match saHeaderRule "\w\+\>" contained nextgroup=saHeaderHeaderPre,saEval,saHeaderHeader skipwhite
    syn keyword saHeaderHeaderPre exists contained nextgroup=saHeaderExistsColon
      syn match saHeaderExistsColon ":" contained nextgroup=saHeaderRuleSpecials
    syn match saHeaderHeader "[^:[:space:]]\+" contained nextgroup=saHeaderHeaderPost,saHeaderMatch contains=saHeaderRuleSpecials,saMatchParent,saHeaderMatch
        syn keyword saHeaderRuleSpecials ALL ToCc EnvelopeFrom MESSAGEID contained
        syn match saHeaderRuleSpecials "\<ALL-\%(\%(UN\)?TRUSTED\|\%(IN\|EX\)TERNAL\)\>" contained
        syn match saHeaderRuleSpecials "\<X-Spam-Relays-\%(\%(Unt\|T\)rusted\|\%(In\|Ex\)ternal\)\>" contained
      syn match saHeaderHeaderPost ":" contained nextgroup=saHeaderHeaderPostWord
      syn keyword saHeaderHeaderPostWord raw addr name contained nextgroup=saHeaderMatch
      syn match saHeaderMatch "\s\+[=!]\~" contained nextgroup=saMatchParent,saBodyMatch skipwhite

" this 'should' be contained (but not by saBodyMatch) somehow
syn match saHeaderPost "\[if-unset:" nextgroup=saUnset skipwhite
  syn match saUnset "[^\]]*" contained nextgroup=saUnsetEnd
    syn match saUnsetEnd "\]" contained

" rule descriptions recommended max length is 50
syn keyword saDescribe describe contained nextgroup=saDescRule skipwhite
  syn match saDescRule "\w\+\>" contained nextgroup=saDescription skipwhite
    syn match saDescription "\S.\{0,50\}" contained contains=saComment,saURL,@Spell nextgroup=saDescribeOverflow1
      " interrupt saURL color, but don't spellcheck the next part
      syn region saDescribeOverflow1 start=+.+ end="[^-A-Za-z0-9_.:@/#%,;~?+=&]" oneline contained contains=@NoSpell nextgroup=saDescribeOverflow2
        " spellchecking may resume
        syn match saDescribeOverflow2 ".\+$" contained contains=@Spell,saComment

" body rules have regular expressions w/out a leading =~
syn region saBodyMatch matchgroup=saMatchStartEnd start=:/: end=:/[cgimosx]*\%(\s\|$\): contains=@perlInterpSlash,saMatchParent oneline contained nextgroup=saComment,saError skipwhite

syn keyword saType rawbody body full contained nextgroup=saBodyRule skipwhite
  syn match saBodyRule "\w\+\>" contained nextgroup=saEval,saMatchParent,saBodyMatch skipwhite
" uri can't contain saEval
syn keyword saType uri contained nextgroup=saUriRule skipwhite
  syn match saUriRule "\w\+\>" contained nextgroup=saMatchParent,saBodyMatch skipwhite

syn keyword saType tflags contained nextgroup=saTFlagsRule skipwhite
  syn match saTFlagsRule "\w\+\>" contained nextgroup=saTFlagsList skipwhite
    syn match saTFlagsList "\S.*" contained contains=@saTFlags,saErrWord
      syn keyword saBaseTFlags net nice learn userconf noautolearn multiple publish nopublish contained

syn keyword saAdmin version_tag test rbl_timeout util_rb_tld util_rb_2tld loadplugin tryplugin contained

syn keyword saAdminBayes bayes_path bayes_file_mode bayes_store_module bayes_sql_dsn contained
syn keyword saAdminBayes bayes_sql_username bayes_sql_password bayes_sql_username_authorized contained

syn keyword saAdminScores user_scores_dsn user_scores_sql_username user_scores_sql_password contained
syn keyword saAdminScores user_scores_ldap_username user_scores_ldap_password contained
syn keyword saAdminScores user_scores_sql_custom_query contained nextgroup=saSQLcustom skipwhite
  syn match saSQLcustom  "\S.*" contained contains=saSQLTags,saComment
    " Note, these are NOT template tags (thus no membership in saTemplateTags)
    syn keyword saSQLTags _TABLE_ _USERNAME_ _MAILBOX_ _DOMAIN_ contained

syn keyword saPreProc include ifplugin else endif require_version contained
syn keyword saPreProc if contained nextgroup=saIfsLine skipwhite
  syn match saIfsLine "\S.*" contained contains=saIfKey,saIfFunc,saNumber,saParens,saMetaOp,saComment
  syn keyword saIfKey version contained
  syn keyword saIfFunc plugin can contained
syn match saAtWord "@@\w\+@@" containedin=saComment

syn keyword saType meta contained nextgroup=saMetaRule skipwhite
  syn match saMetaRule "\w\+\>" contained nextgroup=saMeta skipwhite
    syn match saMeta "\S.*" contained contains=saMetaOp,saParens,saPredicate,saTestRule,saComment,saNumber,saRuleNames
      syn match saMetaOp "[^[:punct:]]\@<=\%(||\|&&\|[-+*/]\|[!><=]=\?\)[^[:punct:]]\@=" contained



"""""""""""""
" PLUGINS (that ship enabled with SpamAssassin, small plugins are above)
"          This section stands as an example for supporting other plugins.
"          Nothing below this line is referred to by an earlier line.

syn cluster saRule add=saHashChecks,saVerify,saDNSBL,saReplace
syn cluster saTemplateTags add=saDKIMtags
syn cluster saFunction add=saVerifyFunc,saDNSBLfunc

" Pyzor, Razor2, Hashcash
syn keyword saHashChecks use_pyzor pyzor_max pyzor_timeout pyzor_options pyzor_path contained
syn keyword saHashChecks use_razor2 razor_timeout razor_config  use_hashcash hashcash_accept contained
syn keyword saHashChecks hashcash_doublespend_path hashcash_doublespend_file_mode contained

" SPF, DKIM
syn keyword saVerify whitelist_from_spf def_whitelist_from_spf spf_timeout do_not_use_mail_spf contained
syn keyword saVerify do_not_use_mail_spq_query ignore_received_spf_header contained
syn keyword saVerify use_newest_received_spf_header contained
syn keyword saVerify whitelist_from_dkim def_whitelist_from_dkim dkim_timeout domainkeys_timeout contained
syn keyword saVerifyFunc check_dkim_valid check_dkim_valid_author_sig check_dkim_verified contained
syn keyword saDKIMtags _DKIMIDENTIFY_ _DKIMDOMAIN_ contained

" SpamCop and URIDNSBL
syn keyword saDNSBL spamcop_from_address spamcop_to_address spamcop_max_report_size contained
syn keyword saDNSBL uridnsbl_skip_domain uridnsbl_max_domains contained
syn keyword saDNSBL uridnsbl uridnsbl uridnssub urirhsbl urirhssub urinsrhsbl urinsrhssub urifullnsrhsbl urifullnsrhssub contained nextgroup=saURIBLRule skipwhite
  syn match saURIBLRule "\w\+\>" contained nextgroup=saURIBLData
    syn match saURIBLData "\s\+\S\+\s\+" contained nextgroup=saURIBLkeys
      syn keyword saURIBLkeys A TXT contained
syn keyword saDNSBLfunc check_uridnsbl contained

" ReplaceTags
syn keyword saReplace replace_start replace_end replace_rules contained
syn keyword saReplace replace_tag replace_pre replace_inter replace_post contained nextgroup=saReplaceTag skipwhite
  syn match saReplaceTag "\w\+\>" contained nextgroup=saString skipwhite

" URIDetail
syn keyword saURIDetail uri_detail contained nextgroup=saURIDetailRule skipwhite
  syn match saURIDetailRule "\w\+\>" contained nextgroup=saURIDetailLine skipwhite
    syn match saURIDetailLine "\S.*" contained contains=saURIDetailKeys,saHeaderMatch,saMatchParent,saErrWord,saComment
      syn keyword saURIDetailKeys raw type cleaned text domain contained


"""""""""""""
" Plugins disabled by default

syn cluster saRule add=saDCC,saAWL,saLang,saShortCircuit,saASN,saPhishTag
syn cluster saTemplateTags add=saAWLtags,saShortCircuitTags,saASNtags
syn cluster saRuleNames add=saShortCircuitRule,saPTrule
syn cluster saKeyword add=saShortCircuitKeys
syn cluster saFunction add=saAVfunc,saAWLfunc,saAccessDBfunc

" DCC
syn keyword saDCC use_dcc dcc_body_max dcc_fuz1_max dcc_fuz2_max dcc_timeout contained
syn keyword saDCC dcc_home dcc_dccifd_path dcc_path dcc_options dccifd_options contained

" AntiVirus
syn keyword saAVfunc check_microsoft_executable check_suspect_name contained

" AWL
syn keyword saAWL use_auto_whitelist auto_whitelist_factor user_awl_override_username contained
syn keyword saAWL auto_whitelist_path auto_whitelist_db_modules auto_whitelist_file_mode contained
syn keyword saAWL user_awl_dsn user_awl_sql_username user_awl_sql_password user_awl_sql_table contained
syn keyword saAWLfunc check_from_in_auto_whitelist contained
syn keyword saAWLtags _AWL_ _AWLMEAN_ _AWLCOUNT_ _AWLPRESCORE_ contained

" TextCat (see also saTR and saLocale above)
syn keyword saLang ok_languages inactive_languages contained nextgroup=saLangList,saError skipwhite
  syn match saLangList "[a-z]\{2\}\S\{0,8\}\>" contained nextgroup=saLangList,saErrWord skipwhite contains=saLangKeys,saErrWord
syn keyword saLang textcat_max_languages textcat_optimal_ngrams contained
syn keyword saLang textcat_max_ngrams textcat_acceptable_score contained

" AccessDB
syn keyword saAccessDBfunc check_access_database contained

" Shortcircuit
syn keyword saShortCircuit shortcircuit shortcircuit_spam_score shortcircuit_ham_score contained nextgroup=saShortCircuitRule skipwhite
  syn match saShortCircuitRule "\w\+\>" contained nextgroup=saShortCircuitKeys,saErrWord skipwhite
    syn keyword saShortCircuitKeys ham spam on off contained
syn keyword saShortCircuitTags _SC_ _SCRULE_ _SCTYPE_ contained

" ASN
syn keyword saASN asn_lookup contained nextgroup=saASNdomain skipwhite
  syn match saASNdomain "\S\+" contained nextgroup=saASNtags skipwhite
syn keyword saASNtags _ASN_ _ASNCIDR_ _ASNCIDRTAG_ _ASNDATA_ contained nextgroup=saASNtags skipwhite
syn keyword saASNtags _ASNTAG_ _COMBINEDASN_ _COMBINEDASNCIDR_ contained nextgroup=saASNtags skipwhite
syn keyword saASNtags _MYASN_ _MYASNCIDR_ contained nextgroup=saASNtags skipwhite

" PhishTag
syn keyword saPhishTag trigger_ratio contained nextgroup=saNumber skipwhite
syn keyword saPhishTag trigger_target contained nextgroup=saPTrule skipwhite
  syn match saPTrule "\w\+\>" contained nextgroup=saURL,saError skipwhite


"""""""""""""
" Some 3rd-party plugins (not shipped with SA, simple plugins only)

syn cluster saRule add=saPluginMisc
syn cluster saFunction add=saPluginMiscFunc

syn keyword saPluginMisc uricountry sagrey_header_field popauth_hash_file contained
syn keyword saPluginMiscFunc ixhashtest contained



"""""""""""""
" Colors

hi def link saQuote			String
hi def link saTodo			Todo
hi def link saComment			Comment
hi def link saMatch			String
hi def link saMatchStartEnd		Statement
hi def link saError			Error
hi def link saErrWord			saError
hi def link saWrongMatchOp 		saError
hi def link saAtWord			saError
hi def link saParens			Structure
hi def link saNumber			Float
hi def link saIPaddress			Float
"hi def link saURL			Underlined
"hi def link saPath 			String
hi def link saEmail			Type
hi def link saEmailGlob			Operator
hi def link saString			String

" (why can't I define clusters here?)
hi def link saRule			Statement
hi def link saKeyword			Type
hi def link saTemplateTags		Type
hi def link saFunction			Function
hi def link saTFlags			Type

hi def link saLists 			Statement
hi def link saHeaderType 		Statement
hi def link saBaseTT			saTemplateTags
hi def link saSQLcustom			saString
hi def link saSQLTags			saTemplateTags
hi def link saLocale 			Statement
hi def link saNet  			Statement
hi def link saBayes 			Statement
hi def link saMisc 			saRule
hi def link saPrivileged 		Statement
hi def link saType 			Statement
hi def link saReport 			saType
hi def link saTR	 		Statement
hi def link saDescribe			saType
hi def link saDescription		String
hi def link saDescribeOverflow1 	Error
hi def link saDescribeOverflow2 	saDescribeOverflow1
hi def link saBaseTFlags		saTFlags
hi def link saAdmin 			Statement
hi def link saAdminBayes 		Statement
hi def link saAdminScores 		Statement
hi def link saPreProc 			PreProc
hi def link saBodyMatch			saMatch
hi def link saHeaderRuleSpecials	Type
hi def link saHeaderHeaderPre		Identifier
hi def link saEval 			Identifier
hi def link saHeaderHeaderPostWord	Type
hi def link saHeaderPost		Type
hi def link saUnsetEnd			saHeaderPost
hi def link saLangKeys			saKeyword
hi def link saIfKey			saKeyword
hi def link saIfFunc			saFunction
hi def link saLockKeys			saKeyword
hi def link saHeaderClauseList		Type
hi def link saHeaderRWName		Type
hi def link saHeaderString		String
hi def link saFunctionString		String
hi def link saMetaOp			Operator
hi def link saPredicate			Comment
hi def link saTestRule			Debug
hi def link saHeaderMatch		Operator

hi def link saDCC			saRule
hi def link saHashChecks		saRule
hi def link saVerify			saRule
hi def link saDNSBL			saRule
hi def link saAWL			saRule
hi def link saShortCircuit 		saRule
hi def link saLang 			saLocale
hi def link saASN			saRule
hi def link saReplace			saRule
hi def link saURIDetail			saRule
hi def link saPhishTag			saRule
hi def link saPluginMisc		saRule

hi def link saURIBLkeys			saKeyword
hi def link saShortCircuitKeys		saKeyword
hi def link saURIDetailKeys		saKeyword
hi def link saLocaleKeys		saLangKeys

hi def link saASNtags			saTemplateTags
hi def link saDKIMtags			saTemplateTags
hi def link saAWLtags			saTemplateTags
hi def link saShortCircuitTags		saTemplateTags

hi def link saVerifyFunc		saFunction
hi def link saDNSBLfunc			saFunction
hi def link saAVfunc			saFunction
hi def link saAWLfunc			saFunction
hi def link saAccessDBfunc		saFunction
hi def link saPluginMiscFunc		saFunction
