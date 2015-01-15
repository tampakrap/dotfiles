dofile("/home/tampakrap/.imapfilter/common.lua")

status, password = pipe_from('~/bin/getmailpass.py suse')
password = password.gsub(password, ' ', '').gsub(password, '\n', '')

gentoo = IMAP {
    server = 'imap.suse.de',
    username = 'tchatzimichos',
    password = password,
    ssl = 'tls1',
    port = 993,
}

gentoo_all = gentoo['INBOX']:select_all()
gentoo_new = gentoo['INBOX']:is_new()
gentoo_recent = gentoo['INBOX']:is_recent()
gentoo_unseen = gentoo['INBOX']:is_unseen()
