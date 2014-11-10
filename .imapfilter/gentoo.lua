dofile("/home/tampakrap/.imapfilter/common.lua")

status, password = pipe_from('~/bin/getmailpass gentoo')
password = password.gsub(password, ' ', '').gsub(password, '\n', '')

gentoo = IMAP {
    server = 'mail.gentoo.org',
    username = 'tampakrap',
    password = password,
    ssl = 'tls1.2',
    port = 993,
}

gentoo_all = gentoo['INBOX']:select_all()
gentoo_new = gentoo['INBOX']:is_new()
gentoo_recent = gentoo['INBOX']:is_recent()

spam = gentoo_recent:match_field('X-Spam-Flag', 'YES') + gentoo_recent:match_from('(goldenmarketing|qnews|traficfcs|panel25|payapars|simedi)\\.ir|planetfone\\.com\\.br|(poworsave|waimaoedm|newageink|zyoux|allarelbus|messbest)\\.com|promofast\\.info|(cp-mi|miks-it)\\.ru|(ussolardept|amazonclickhere)\\.eu|zeraimundo1515\\.net|almanet\\.tk|(flywer|lwtyui)\\.asia')
spam:move_messages(gentoo['spam'])

gentoo_recent:match_field('X-BeenThere', 'gentoo-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-announce'])
gentoo_recent:match_field('X-BeenThere', 'gentoo-core@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-core'])
gentoo_recent:match_field('X-BeenThere', 'gentoo-dev-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-dev-announce'])
gentoo_recent:match_field('X-BeenThere', 'gentoo-foundation-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-foundation-announce'])
gentoo_recent:match_field('X-BeenThere', 'gentoo-soc@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-soc'])
gentoo_recent:match_field('X-BeenThere', 'gentoo-user-cs@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-user-cs'])
gentoo_recent:match_field('X-BeenThere', 'gentoo-user-el@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-user-el'])
bugzilla = gentoo_recent:contain_from('bugzilla-daemon@gentoo.org')
bugzilla:contain_to('tampakrap@gentoo.org'):move_messages(gentoo['logs/bugzilla'])
bugzilla:contain_to('suse@gentoo.org'):move_messages(gentoo['logs/suse'])
blogs = gentoo_recent:contain_from('wordpress@blogs.gentoo.org')
myblog = blogs:contain_subject('[the purple greeko]')
myblog:move_messages(gentoo['logs/blog'])
gentoo_recent:match_from('((noreply|support)@github|notifications@travis-ci)\\.com'):move_messages(gentoo['logs/github'])
