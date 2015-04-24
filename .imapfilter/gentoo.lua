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

gentoo:delete_mailbox('from_old')
gentoo:delete_mailbox('logs/bugzilla/infra-bugs')
gentoo:delete_mailbox('logs/bugzilla/overlays')
gentoo:delete_mailbox('logs/bugzilla/planet')
gentoo:delete_mailbox('logs/bugzilla/suse')
gentoo:delete_mailbox('logs/bugzilla/sysadmin')

spam = gentoo_unseen:match_field('X-Spam-Flag', 'YES') + gentoo_unseen:match_from('gricciardi\\.com\\.ar|(flywer|lwtyui)\\.asia|promo-bg\\.biz|((planetfone|brasilalemanhaneues)\\.com|pbh\\.gov)\\.br|colorusb\\.cn|(poworsave|waimaoedm|newageink|zyoux|allarelbus|messbest|richvalvee|powersqve|plazatur|ac2tech|126|industries-eu|partsbuy|sohu|gadget-academy|newdensen|insurer|sz-xsn|enigmaadvertising|uuuddii|newdensen|combis-(info|community)|arabianbateelcorp|friendango|sarinawebdesign|eseateqiao|hxtradehx|bizdiagnosis|gaphu|mailbulteni|eu-coverages|163|davidrodriguezsanchez|bestser|online-tanitim|ctvsltns|2015marzo|makinvest1|homecarefoyou)\\.com|carpandfun\\.de|uab\\.edu|(ussolardept|amazonclickhere|niekerele|kfvoeirf|aeoire)\\.eu|maison-jardin-deco\\.fr|usps\\.gov|(solution|call|glossary)\\.gen)\\.in|promofast\\.info|(goldenmarketing|qnews|traficfcs|panel25|payapars|simedi|digiyar)\\.ir|mircodellavecchia\\.it|upnm\\.edu\\.my|(zeraimundo1515|spitfireukicursos2015|medianetrix|ameritech|entrust|daum|linkwebdesignservices|sarina|credu|jesult|philipids|obsers|ovemen|buy-realfans)\\.net|(dnstate|grantfundingusa|cadeautheque)\\.org|viamail\\.pt|islato\\.pw|kabelkon\\.ro|(cp-mi|miks-it|bk|lolern)\\.ru|(planet|map\\.com|air-voyage)\\.tn|(splaim|symput|requet|kubrew|carnly|fupt|naival|hish|ount|slea|espila|xoched|gezx|suppoy|overation|radige|vcvp|devass)\\.top|(almanet|bimeh)\\.tk|century\\.vni|(successex|docustem|monfle|toronate|alkansas|conflicki|sincett|enound|bigga|bnjgl4|graecil|saintact)\\.xyz')
spam:move_messages(gentoo['spam'])

hosting_all = '(infra-(4launch|amazon|eukhost|globalsign|gossamer|hetzner|leaseweb|mti|ovh|rackspace|rax(-master)?|vr)@gentoo|(support|hosting)@osuosl)\\.org|communication@magic\\.fr|s(ales|upport)@7l|support@gossamerhost\\.com|(support|buchhaltung)@manitu\\.de|support@inerail.net'
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
logs = gentoo_unseen:match_from('(g(archives|cvsd-rsync|infrastatus|web|mirror|qa|packages|planet)|root|apache|MAILER-DAEMON)@gentoo\\.org'):match_to('(root|gweb|infra-automated-retire|recruiters|planet)@gentoo\\.org') + gentoo_unseen:contain_from('root@osprey.gentoo.org'):contain_to('root') + gentoo_unseen:contain_from('ipmi@bittern.gentoo.oob') + gentoo_unseen:contain_to('root@gentoo.org'):match_subject('[*]{3} SECURITY information for [a-z]+ [*]{3}')
logs:move_messages(gentoo['logs'])
blogs = gentoo_unseen:contain_from('wordpress@blogs.gentoo.org')
myblog = blogs:contain_subject('[the purple greeko]')
blogs:move_messages(gentoo['logs'])
myblog:move_messages(gentoo['logs/blog'])
bugzilla = gentoo_unseen:contain_from('bugzilla-daemon@gentoo.org'):move_messages(gentoo['logs/bugzilla'])
gentoo_unseen:contain_to('cfengine@gentoo.org'):move_messages(gentoo['logs/cfengine'])
gentoo_unseen:match_from('(icinga@gentoo|nagios@osuosl)\\.org'):move_messages(gentoo['logs/icinga'])
github = gentoo_unseen:match_from('((noreply|support|notifications)@github|(notifications|builds)@travis-ci)\\.com') + gentoo_unseen:contain_from('X-GitHub-Recipient', 'tampakrap')
github:move_messages(gentoo['logs/github'])
gentoo_unseen:contain_to('infra-commits@gentoo.org'):move_messages(gentoo['logs/infra-commits'])
gentoo_unseen:contain_from('puppet@puppetmaster.gentoo.org'):move_messages(gentoo['logs/puppet'])
gentoo_unseen:match_from('donotreply@wordpress\\.com'):move_messages(gentoo['newsletters'])
