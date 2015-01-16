dofile("/home/tampakrap/.imapfilter/common.lua")

status, password = pipe_from('~/bin/getmailpass.py novell')
password = password.gsub(password, ' ', '').gsub(password, '\n', '')

novell = IMAP {
    server = 'gwmail.emea.novell.com',
    username = 'tchatzimichos',
    password = password,
    ssl = 'tls1',
    port = 993,
}

novell_all = novell['INBOX']:select_all()
novell_new = novell['INBOX']:is_new()
novell_recent = novell['INBOX']:is_recent()
novell_unseen = novell['INBOX']:is_unseen()
