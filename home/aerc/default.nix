{ pkgs, config, ... }:
let
  sharedir = "${pkgs.aerc}/share/aerc";
  libexec = "${pkgs.aerc}/libexec/aerc";
  filters = "${libexec}/filters";
in
{
  home.packages = [
    pkgs.aerc
  ];

  xdg.configFile."aerc/binds.conf".source = ../config/aerc/binds.conf;
  xdg.configFile."aerc/stylesets/solarized".source = ../config/aerc/solarized;
  xdg.configFile."aerc/accounts.conf".source = ../config/aerc/accounts.conf;
  xdg.configFile."aerc/templates/quoted_html_reply".text= ''
  {{ if or
	(eq .OriginalMIMEType "text/html")
	(contains (toLower .OriginalText) "<html")
}}
	{{- $text := exec `${filters}/html` .OriginalText | replace `\r` `` -}}
	{{- range split "\n" $text -}}
		{{- if eq . "References:" }}{{break}}{{end}}
		{{- if or
			(eq (len .) 0)
			(match `^\[.+\]\s*$` .)
		}}{{continue}}{{end}}
		{{- printf "%s\n" . | replace `^[\s]+` "" | quote}}
	{{- end -}}
{{- else }}
	{{- trimSignature .OriginalText | quote -}}
{{- end -}}

{{.Signature -}}
  '';

  xdg.configFile."aerc/aerc.conf".text = ''
    [general]
    # No password in accounts.conf so this is safe
    unsafe-accounts-conf=true

    [ui]
    threading-enabled=true

    dirlist-left = {{.Folder}}
    dirlist-right = {{if .Unread}}{{humanReadable .Unread}}/{{end}}{{if .Exists}}{{humanReadable .Exists}}{{end}}

    #
    # See time.Time#Format at https://godoc.org/time#Time.Format
    #
    # Default: 2006-01-02 03:04 PM (ISO 8601 + 12 hour time)
    timestamp-format=2006-01-02 03:04 PM

    #
    # Width of the sidebar, including the border.
    #
    # Default: 20
    sidebar-width=32

    #
    # Message to display when viewing an empty folder.
    #
    # Default: (no messages)
    empty-message=(no messages)

    # Message to display when no folders exists or are all filtered
    #
    # Default: (no folders)
    empty-dirlist=(no folders)

    # Enable mouse events in the ui, e.g. clicking and scrolling with the mousewheel
    #
    # Default: false
    mouse-enabled=false

    #
    # Ring the bell when new messages are received
    #
    # Default: true
    new-message-bell=false

    # Marker to show before a pinned tab's name.
    #
    # Default: `
    pinned-tab-marker='`'

    # Describes the format string to use for the directory list


    # List of space-separated criteria to sort the messages by, see *sort*
    # command in *aerc*(1) for reference. Prefixing a criterion with "-r "
    # reverses that criterion.
    #
    # Example: "from -r date"
    #
    # Default: ""
    sort=

    # Moves to next message when the current message is deleted
    #
    # Default: true
    next-message-on-delete=true

    stylesets-dirs=/home/shaw/.config/aerc/stylesets

    styleset-name=solarized

    border-char-vertical=│

    #
    # Describes the format for each row in a mailbox view.
    #
    index-columns = date<=,name<35,flags>4,subject<*
    column-date = {{.DateAutoFormat .Date.Local}}
    column-name = {{index (.From | names) 0}}
    column-flags = {{.Flags | join ""}}
    column-subject = {{.ThreadPrefix}}{{.Subject}}

    message-list-split=vertical ${toString config.my.aerc.messageListVerticalSplitSize}

    [viewer]
    #
    # Specifies the pager to use when displaying emails. Note that some filters
    # may add ANSI codes to add color to rendered emails, so you may want to use a
    # pager which supports ANSI codes.
    #
    # Default: less -R
    #pager=nvim -R -c 'set laststatus=1' -c 'lua vim.opt.showtabline=1'

    #
    # If an email offers several versions (multipart), you can configure which
    # mimetype to prefer. For example, this can be used to prefer plaintext over
    # html emails.
    #
    # Default: text/plain,text/html
    alternatives=text/html,text/plain

    #
    # Default setting to determine whether to show full headers or only parsed
    # ones in message viewer.
    #
    # Default: false
    show-headers=false

    #
    # Layout of headers when viewing a message. To display multiple headers in the
    # same row, separate them with a pipe, e.g. "From|To". Rows will be hidden if
    # none of their specified headers are present in the message.
    #
    # Default: From|To,Cc|Bcc,Date,Subject
    header-layout=From|To,Cc|Bcc,Date,Subject

    # Whether to always show the mimetype of an email, even when it is just a single part
    #
    # Default: false
    always-show-mime=false

    # How long to wait after the last input before auto-completion is triggered.
    #
    # Default: 250ms
    completion-delay=250ms

    #
    # Global switch for completion popovers
    #
    # Default: true
    completion-popovers=true

    [compose]
    #
    # Specifies the command to run the editor with. It will be shown in an embedded
    # terminal, though it may also launch a graphical window if the environment
    # supports it. Defaults to $EDITOR, or vi.
    #editor=nvim -c 'lua vim.opt.showtable=1'
    editor=nvim

    #
    # Default header fields to display when composing a message. To display
    # multiple headers in the same row, separate them with a pipe, e.g. "To|From".
    #
    # Default: To|From,Subject
    header-layout=To|From,Subject

    #
    # Specifies the command to be used to tab-complete email addresses. Any
    # occurrence of "%s" in the address-book-cmd will be replaced with what the
    # user has typed so far.
    #
    # The command must output the completions to standard output, one completion
    # per line. Each line must be tab-delimited, with an email address occurring as
    # the first field. Only the email address field is required. The second field,
    # if present, will be treated as the contact name. Additional fields are
    # ignored.
    address-book-cmd=

    [filters]
    #
    # Filters allow you to pipe an email body through a shell command to render
    # certain emails differently, e.g. highlighting them with ANSI escape codes.
    #
    # The first filter which matches the email's mimetype will be used, so order
    # them from most to least specific.
    #
    # You can also match on non-mimetypes, by prefixing with the header to match
    # against (non-case-sensitive) and a comma, e.g. subject,text will match a
    # subject which contains "text". Use header,~regex to match against a regex.
    subject,~^\[PATCH=awk -f ${filters}/hldiff
    text/html=${filters}/html
    text/*=awk -f ${filters}/plaintext
    #image/*=catimg -w $(tput cols) -

    [triggers]
    #
    # Triggers specify commands to execute when certain events occur.
    #
    # Example:
    # new-email=exec notify-send "New email from %n" "%s"

    #
    # Executed when a new email arrives in the selected folder

    [templates]
    # Templates are used to populate email bodies automatically.
    #

    # The directories where the templates are stored. It takes a colon-separated
    # list of directories.
    #
    # default: @SHAREDIR@/templates/
    template-dirs=${sharedir}/templates/:${config.xdg.configHome}/aerc/templates

    # The template to be used for quoted replies.
    #
    # default: quoted_reply
    quoted-reply=quoted_html_reply

    # The template to be used for forward as body.
    #
    # default: forward_as_body
    forwards=forward_as_body

    [hooks]
      mail received=exec notify-send "New email from $AERC_FROM_NAME" "$AERC_SUBJECT"
  '';
}
