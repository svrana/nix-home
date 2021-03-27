// ==UserScript==
// @name        github Solarized Dark Theme
// @namespace   https://lwn.net/
// @match       https://lwn.net/
// @grant       none
// @version     1.0
// @author      @alphapaper
// @description 2/19/2020, 3:26:24 PM
// ==/UserScript==

GM_addStyle (`
* {
  border-color: #657b83 !important;
}
a {
  color: #268bd2 !important;
}
a:visited {
  color: #6c71c4 !important;
}
body {
  background-color: #002b36 !important;
  color: #839496 !important;
}
html {
  background-color: #002b36 !important;
}
input,
textarea {
  background-color: #073642 !important;
  color: #839496 !important;
}
blockquote,
pre {
  background-color: #073642 !important;
  color: #839496 !important;
}
tr.Even {
  background-color: #073642 !important;
}
.BigQuote {
  background-color: #073642 !important;
  color: #cb4b16 !important;
}
.Cat1HL {
  background-color: #586e75 !important;
  color: #93a1a1 !important;
}
.Cat2HL {
  background-color: #094352 !important;
}
.Cat3HL {
  background-color: #083c4a !important;
}
.FeatureByline {
  background-color: #073642 !important;
  border: none !important;
}
.Headline {
  background-color: #094352 !important;
}
.QuotedText {
  color: #6c71c4 !important;
}
DIV.GAByline {
  background-color: #073642 !important;
  border: none !important;
}
table.OddEven tr:nth-child(even) {
  background-color: #00323f !important;
}
table.OddEven tr:nth-child(odd) {
  background-color: #002b36 !important;
}
DIV.CommentBox {
  border-color: #073642 !important;
}
DIV.CommentBox P.CommentTitle {
  background-color: #094352 !important;
}
#menu,
.topnav-container {
  background-color: #073642 !important;
}
.navmenu ul {
  background-color: #073642 !important;
}
`)
