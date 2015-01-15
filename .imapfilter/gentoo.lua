dofile("/home/tampakrap/.imapfilter/common.lua")

status, password = pipe_from('~/bin/getmailpass.py gentoo')
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
gentoo_unseen = gentoo['INBOX']:is_unseen()

spam = gentoo_unseen:match_field('X-Spam-Flag', 'YES') + gentoo_unseen:match_from('(goldenmarketing|qnews|traficfcs|panel25|payapars|simedi)\\.ir|planetfone\\.com\\.br|(poworsave|waimaoedm|newageink|zyoux|allarelbus|messbest|mx2\\.richvalvee)\\.com|promofast\\.info|(cp-mi|miks-it)\\.ru|(ussolardept|amazonclickhere)\\.eu|zeraimundo1515\\.net|almanet\\.tk|(flywer|lwtyui)\\.asia')
spam:move_messages(gentoo['spam'])

gentoo_unseen:match_field('X-BeenThere', 'gentoo-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-announce'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-core@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-core'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-dev-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-dev-announce'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-foundation-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-foundation-announce'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-soc@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-soc'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-user-cs@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-user-cs'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-user-el@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-user-el'])
gentoo_unseen:match_from('(g(archives|cvsd-rsync|web|mirror|qa|packages)|root)@gentoo\\.org'):match_to('(root|gweb|infra-automated-retire)@gentoo\\.org'):move_messages(gentoo['logs'])
bugzilla = gentoo_unseen:contain_from('bugzilla-daemon@gentoo.org')
bugzilla:contain_to('tampakrap@gentoo.org'):move_messages(gentoo['logs/bugzilla'])
bugzilla:contain_to('infra-bugs@gentoo.org'):move_messages(gentoo['logs/bugzilla/infra-bugs'])
bugzilla:contain_to('overlays@gentoo.org'):move_messages(gentoo['logs/bugzilla/overlays'])
bugzilla:contain_to('planet@gentoo.org'):move_messages(gentoo['logs/bugzilla/planet'])
bugzilla:contain_to('suse@gentoo.org'):move_messages(gentoo['logs/bugzilla/suse'])
bugzilla:contain_to('sysadmin@gentoo.org'):move_messages(gentoo['logs/bugzilla/sysadmin'])
blogs = gentoo_unseen:contain_from('wordpress@blogs.gentoo.org')
myblog = blogs:contain_subject('[the purple greeko]')
myblog:move_messages(gentoo['logs/blog'])
gentoo_unseen:contain_to('cfengine@gentoo.org'):move_messages(gentoo['logs/cfengine'])
gentoo_unseen:match_from('(icinga@gentoo|nagios@osuosl)\\.org'):move_messages(gentoo['logs/icinga'])
gentoo_unseen:match_from('((noreply|support)@github|notifications@travis-ci)\\.com'):move_messages(gentoo['logs/github'])
gentoo_unseen:contain_to('infra-commits@gentoo.org'):move_messages(gentoo['logs/infra-commits'])
gentoo_unseen:contain_from('puppet@puppetmaster.gentoo.org'):move_messages(gentoo['logs/puppet'])
newsletters = gentoo_unseen:match_to('infra-(rax|amazon)@gentoo|hosting@osuosl\\.org') + gentoo_unseen:match_from('communication@magic\\.fr')
newsletters:move_messages(gentoo['newsletters'])
