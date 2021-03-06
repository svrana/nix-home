// ==UserScript==
// @name        DuckDuckGo Solarized Dark Theme
// @namespace   https://duckduckgo.com/
// @match       https://duckduckgo.com/
// @grant       none
// @version     1.0
// @author      @alphapaper
// @description 2/19/2020, 3:26:24 PM
// ==/UserScript==

GM_addStyle ( `
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
.search--adv {
  background-color: #073642 !important;
}
.search__autocomplete > .acp-wrap {
  background-color: #002b36 !important;
}
.search__autocomplete > .acp-wrap > .acp--highlight {
  background-color: #073642 !important;
  color: #eee8d5 !important;
}
.search__autocomplete > .acp-wrap strong {
  color: #eee8d5 !important;
}
.site-wrapper > #header_wrapper {
  background-color: #002b36 !important;
}
.site-wrapper > #header_wrapper > #header {
  background-color: #002b36 !important;
}
.search--header {
  background-color: #073642 !important;
}
.zci {
  background-color: #073642 !important;
  color: #839496 !important;
}
.tile--info {
  background-color: #002b36 !important;
}
.tile--info__expand {
  background-color: #586e75 !important;
}
.tile--c {
  background-color: #586e75 !important;
  color: #eee8d5 !important;
}
.module__text {
  color: #839496 !important;
}
.about-info-box__heading {
  color: #93a1a1 !important;
}
.result.highlight {
  background-color: #073642 !important;
}
.result__snippet {
  color: #839496 !important;
}
.result__snippet b {
  color: #93a1a1 !important;
}
.btn--top {
  background-color: #073642 !important;
  color: #839496 !important;
}
.btn--top:hover {
  background-color: #586e75 !important;
}
.result--sep--hr:before {
  background-color: #586e75 !important;
}
` );
