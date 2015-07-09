dofile("/home/tampakrap/.imapfilter/common.lua")

status, password = pipe_from('~/bin/getmailpass.py gentoo')
password = password.gsub(password, ' ', '').gsub(password, '\n', '')

gentoo = IMAP {
    server = 'mail.gentoo.org',
    username = 'tampakrap',
    password = password,
    ssl = 'tls1.3',
    port = 993,
}

gentoo_all = gentoo['INBOX']:select_all()
gentoo_new = gentoo['INBOX']:is_new()
gentoo_recent = gentoo['INBOX']:is_recent()
gentoo_unseen = gentoo['INBOX']:is_unseen()

gentoo_unseen:match_field('X-BeenThere', 'gentoo-core@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-core'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-dev-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-dev-announce'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-infrastructure@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-infrastructure'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-foundation-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-foundation-announce'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-user-cs@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-user-cs'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-user-el@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-user-el'])
gentoo_unseen:contain_from('bugzilla-daemon@gentoo.org'):move_messages(gentoo['logs'])
gentoo_unseen:match_field('X-Spam-Flag', 'YES'):move_messages(gentoo['spam'])
