dofile("/home/tampakrap/.imapfilter/common.lua")

status, password = pipe_from('~/bin/getmailpass.py seznam')
password = password.gsub(password, ' ', '').gsub(password, '\n', '')

seznam = IMAP {
    server = 'imap.seznam.cz',
    username = 'tampakrap',
    password = password,
    ssl = 'tls1.3',
    port = 993,
}

seznam_all = seznam['INBOX']:select_all()
seznam_new = seznam['INBOX']:is_new()
seznam_recent = seznam['INBOX']:is_recent()
seznam_unseen = seznam['INBOX']:is_unseen()
