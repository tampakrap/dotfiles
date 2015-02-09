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

spam = gentoo_unseen:match_field('X-Spam-Flag', 'YES') + gentoo_unseen:match_from('(goldenmarketing|qnews|traficfcs|panel25|payapars|simedi|digiyar)\\.ir|(planetfone\\.com|pbh\\.gov)\\.br|(poworsave|waimaoedm|newageink|zyoux|allarelbus|messbest|richvalvee|powersqve|plazatur|ac2tech|126|industries-eu|partsbuy|sohu|gadget-academy|newdensen|insurer|sz-xsn|enigmaadvertising|uuuddii|newdensen|combis-info)\\.com|promofast\\.info|(cp-mi|miks-it|bk|lolern)\\.ru|(ussolardept|amazonclickhere|niekerele|kfvoeirf)\\.eu|(zeraimundo1515|spitfireukicursos2015|medianetrix|ameritech|entrust|daum)\\.net|almanet\\.tk|(flywer|lwtyui)\\.asia|(successex|docustem|monfle|toronate|alkansas)\\.xyz|((jesult|philipids)\\.net|sarina|credu|call\\.gen)\\.in|carpandfun\\.de|(planet|map\\.com)\\.tn|mircodellavecchia\\.it|uab\\.edu|(dnstate|grantfundingusa)\\.org|(splaim|symput|requet|kubrew|carnly)\\.top|century\\.vni|colorusb\\.cn|usps\\.gov')
spam:move_messages(gentoo['spam'])

hosting_all = '(infra-(4launch|amazon|eukhost|globalsign|hetzner|mti|rackspace|rax|vr)@gentoo|(support|hosting)@osuosl)\\.org|communication@magic\\.fr|s(ales|upport)@7l\\.com|(support|buchhaltung)@manitu\\.de'
hosting = gentoo_unseen:match_from(hosting_all) + gentoo_unseen:match_to(hosting_all) + gentoo_unseen:match_cc(hosting_all)
hosting:move_messages(gentoo['hosting'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-announce'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-core@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-core'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-dev-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-dev-announce'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-infrastructure@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-infrastructure'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-foundation-announce@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-foundation-announce'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-soc@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-soc'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-user-cs@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-user-cs'])
gentoo_unseen:match_field('X-BeenThere', 'gentoo-user-el@lists\\.gentoo\\.org'):move_messages(gentoo['lists/gentoo-user-el'])
logs = gentoo_unseen:match_from('(g(archives|cvsd-rsync|infrastatus|web|mirror|qa|packages|planet)|root|apache)@gentoo\\.org'):match_to('(root|gweb|infra-automated-retire|recruiters|planet)@gentoo\\.org') + gentoo_unseen:contain_from('root@osprey.gentoo.org'):contain_to('root') + gentoo_unseen:contain_from('ipmi@bittern.gentoo.oob') + gentoo_unseen:contain_to('infra-vr@gentoo.org') + gentoo_unseen:contain_to('root@gentoo.org'):match_subject('[*]{3} SECURITY information for [a-z]+ [*]{3}')
logs:move_messages(gentoo['logs'])
blogs = gentoo_unseen:contain_from('wordpress@blogs.gentoo.org')
myblog = blogs:contain_subject('[the purple greeko]')
blogs:move_messages(gentoo['logs'])
myblog:move_messages(gentoo['logs/blog'])
bugzilla = gentoo_unseen:contain_from('bugzilla-daemon@gentoo.org')
bugzilla:contain_to('tampakrap@gentoo.org'):move_messages(gentoo['logs/bugzilla'])
bugzilla:contain_to('infra-bugs@gentoo.org'):move_messages(gentoo['logs/bugzilla/infra-bugs'])
bugzilla:contain_to('overlays@gentoo.org'):move_messages(gentoo['logs/bugzilla/overlays'])
bugzilla:contain_to('planet@gentoo.org'):move_messages(gentoo['logs/bugzilla/planet'])
bugzilla:contain_to('suse@gentoo.org'):move_messages(gentoo['logs/bugzilla/suse'])
bugzilla:contain_to('sysadmin@gentoo.org'):move_messages(gentoo['logs/bugzilla/sysadmin'])
gentoo_unseen:contain_to('cfengine@gentoo.org'):move_messages(gentoo['logs/cfengine'])
gentoo_unseen:match_from('(icinga@gentoo|nagios@osuosl)\\.org'):move_messages(gentoo['logs/icinga'])
gentoo_unseen:match_from('((noreply|support)@github|notifications@travis-ci)\\.com'):move_messages(gentoo['logs/github'])
gentoo_unseen:contain_to('infra-commits@gentoo.org'):move_messages(gentoo['logs/infra-commits'])
gentoo_unseen:contain_from('puppet@puppetmaster.gentoo.org'):move_messages(gentoo['logs/puppet'])
gentoo_unseen:match_from('donotreply@wordpress\\.com'):move_messages(gentoo['newsletters'])
