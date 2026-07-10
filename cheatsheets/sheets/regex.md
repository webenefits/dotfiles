# regex

## Anker
^                                         - Anfang der Zeile/des Strings
$                                         - Ende der Zeile/des Strings
\b                                        - Wortgrenze
\B                                        - keine Wortgrenze
\A                                        - Anfang des gesamten Strings (PCRE)
\z                                        - Ende des gesamten Strings (PCRE)
\Z                                        - Ende, optional vor letztem \n (PCRE)
\G                                        - Position des vorherigen Match-Endes

## Zeichenklassen
.                                         - beliebiges Zeichen (außer \n)
[abc]                                     - eines der Zeichen a, b oder c
[^abc]                                    - jedes Zeichen außer a, b, c
[a-z]                                     - Zeichenbereich a bis z
[a-zA-Z0-9]                               - Buchstaben und Ziffern
\d                                        - Ziffer, entspricht [0-9]
\D                                        - keine Ziffer
\w                                        - Wortzeichen [A-Za-z0-9_]
\W                                        - kein Wortzeichen
\s                                        - Whitespace (Leerzeichen, Tab, \n)
\S                                        - kein Whitespace

## Quantifizierer
a?                                        - null oder ein a (optional)
a*                                        - null oder mehr a
a+                                        - ein oder mehr a
a{3}                                      - genau 3 a
a{3,}                                     - 3 oder mehr a
a{3,6}                                    - 3 bis 6 a
a*?                                       - lazy: so wenige wie möglich
a+?                                       - lazy: mind. eins, so wenige wie möglich
a??                                       - lazy: bevorzugt null
a*+                                       - possessiv: kein Backtracking (PCRE)
a++                                       - possessiv: greift maximal, kein Backtrack

## Gruppen & Alternativen
(...)                                     - Capture-Gruppe (nummeriert)
(?:...)                                   - Gruppe ohne Capture
(?<name>...)                              - benannte Capture-Gruppe
(?P<name>...)                             - benannte Gruppe (Python-Syntax)
a|b                                       - a oder b (Alternative)
(?>...)                                   - atomare Gruppe (kein Backtracking)
(?i)                                      - Inline-Flag ab hier (z. B. i)
(?i:...)                                  - Flag nur für diese Gruppe

## Lookahead / Lookbehind (Lookaround)
foo(?=bar)                                - positives Lookahead: foo nur wenn bar folgt
foo(?!bar)                                - negatives Lookahead: foo nur wenn NICHT bar folgt
(?<=bar)foo                               - positives Lookbehind: foo nur wenn bar davor
(?<!bar)foo                               - negatives Lookbehind: foo nur wenn NICHT bar davor
q(?=u)                                    - q gefolgt von u (u nicht Teil des Matches)
q(?!u)                                    - q nicht gefolgt von u
(?<=\$)\d+                                - Zahl nur nach einem $-Zeichen
(?<!\\)"                                  - " das nicht mit \ escaped ist
\d+(?= ?€)                                - Zahl vor optionalem Leerzeichen und €
(?=.*[A-Z])(?=.*\d).{8,}                  - Passwort: >=1 Großbuchstabe, >=1 Ziffer, min. 8 Zeichen
\d{1,3}(?=(\d{3})+(?!\d))                 - Tausender-Position für Zifferngruppierung

## Referenzen (Backreferences)
\1                                        - Rückbezug auf 1. Capture-Gruppe
\k<name>                                  - Rückbezug auf benannte Gruppe
(?1)                                      - Subroutine: Muster von Gruppe 1 erneut (PCRE)
$1                                        - 1. Gruppe im Ersetzungstext (Ersetzen)
${name}                                   - benannte Gruppe im Ersetzungstext
$&                                        - kompletter Match im Ersetzungstext

## Escapes & Sonderzeichen
\.                                        - wörtlicher Punkt
\\                                        - wörtlicher Backslash
\n \r \t                                  - Newline, Carriage Return, Tab
\uHHHH                                    - Unicode-Codepoint (4 Hex-Stellen)
\xHH                                      - Zeichen per Hex-Code
\p{L}                                     - Unicode-Kategorie Buchstabe (u-Flag/PCRE)
\P{L}                                     - Unicode-Kategorie NICHT Buchstabe
\Q...\E                                   - Bereich wörtlich (Quoting, PCRE)

## Flags / Modifier
i                                         - case-insensitive
g                                         - global (alle Treffer)
m                                         - multiline: ^ und $ je Zeile
s                                         - dotall: . matcht auch \n
x                                         - extended/verbose: Whitespace ignoriert
u                                         - Unicode-Modus
y                                         - sticky: Match ab lastIndex (JS)

## POSIX-Klassen
[[:alpha:]]                               - Buchstaben
[[:alnum:]]                               - Buchstaben und Ziffern
[[:digit:]]                               - Ziffern
[[:space:]]                               - Whitespace
[[:upper:]]                               - Großbuchstaben
[[:lower:]]                               - Kleinbuchstaben
[[:punct:]]                               - Satzzeichen

## Praktische Muster
^\d{4}-\d{2}-\d{2}$                       - Datum ISO (YYYY-MM-DD)
^[\w.+-]+@[\w-]+\.[\w.-]+$                 - grobe E-Mail-Prüfung
^https?://[^\s/$.?#].[^\s]*$              - URL (http/https)
^#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$       - Hex-Farbcode
^(\d{1,3}\.){3}\d{1,3}$                   - IPv4 (ohne Range-Check)
\s+$                                      - trailing Whitespace
^\s*$                                     - leere/nur-Whitespace-Zeile
(["'])(?:\\.|(?!\1).)*\1                  - String in Quotes (mit Escapes)
