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

spam = gentoo_unseen:match_field('X-Spam-Flag', 'YES') + gentoo_unseen:match_from('gricciardi\\.com\\.ar|(flywer|lwtyui)\\.asia|(promo-bg|cariboo)\\.biz|((planetfone|brasilalemanhaneues|revendamais)\\.com|pbh\\.gov)\\.br|(colorusb|hugedata\\.com)\\.cn|(poworsave|waimaoedm|newageink|zyoux|allarelbus|messbest|richvalvee|powersqve|plazatur|ac2tech|126|industries-eu|partsbuy|sohu|gadget-academy|newdensen|insurer|sz-xsn|enigmaadvertising|uuuddii|newdensen|combis-(info|community)|arabianbateelcorp|friendango|sarinawebdesign|eseateqiao|hxtradehx|bizdiagnosis|gaphu|mailbulteni|eu-coverages|163|davidrodriguezsanchez|bestser|online-tanitim|ctvsltns|2015marzo|makinvest1|homecarefoyou|kascert|computertradee|aparattasarimi|namejar|haberfuarsepeti|richledd|support-love|hcavill|prakticheskireshenia|midtnhealth|imacyprus|rostrapr|cupidsboss|olcmebilgisi|computerbracketsolutions|smartmoldtech|buygoogleplus1s|songjw|perfectsign|ottweb|majubersamasama|jinyunmail1|advancementprogress|yourperfectadviser|widemoblecourse|ultrarisesource|cl1p5|izandi|jackhunterx|snowshoeseeds|associateslanguageco|bigfoot|pureworldmakerpro)\\.com|(carpandfun|(front|lated|aerobi|bemijiga)\\.com)\\.de|uab\\.edu|(ussolardept|amazonclickhere|niekerele|kfvoeirf|aeoire|poie|eliteacademy|setli|gibbo|rhoutr|potlu|bingso|gueyre|crapa|bolyanprose|gulch|boxfi|hitti|gifo|galmo|fundaci|formuns|croman|krathi|enchi|doodwa|chho|cannin|attai|bgseminari|dpze|mothe|tasity|pureed|earnivtsi|medfoc)\\.eu|maison-jardin-deco\\.fr|usps\\.gov|(sarina|credu|inboxsender|(jesult|philipids|japarted|studieve|suffect|chhikidn|eatinguish|practure|conoming)\\.net|(solution|call|glossary|myink|truevision|refinance)\\.gen)\\.in|(heiti|promofast|ascen|freehub|memen)\\.info|(goldenmarketing|qnews|traficfcs|panel25|payapars|simedi|digiyar|iranmailshop|medadsystem|hojitoyz|arikamail)\\.ir|(mircodellavecchia|klindexmail)\\.it|sx-persia1\\.ml|upnm\\.edu\\.my|(zeraimundo1515|spitfireukicursos2015|medianetrix|ameritech|entrust|daum|linkwebdesignservices|obsers|ovemen|buy-realfans|telebecinternet|saglikvebeslenme)\\.net|(dnstate|grantfundingusa|cadeautheque|providence)\\.org|cadeautheque\\.pro|viamail\\.pt|islato\\.pw|(kabelkon|vanzariatxcomputers)\\.ro|(cp-mi|miks-it|bk|lolern)\\.ru|(planet|map\\.com|air-voyage|startupalliance)\\.tn|(splaim|symput|requet|kubrew|carnly|fupt|naival|hish|ount|slea|espila|xoched|gezx|suppoy|overation|radige|vcvp|devass)\\.top|(almanet|bimeh|tarashafzar)\\.tk|eclectia\\.com\\.tr|exceedmore\\.us|century\\.vni|(successex|docustem|monfle|toronate|alkansas|conflicki|sincett|enound|bigga|bnjgl4|graecil|saintact)\\.xyz')
spam:move_messages(gentoo['spam'])

hosting_all = '(infra-(4launch|amazon|eukhost|globalsign|gossamer|heartbleed|hetzner|leaseweb|mti|ovh|paypal|rackspace|rax(-master)?|vr)@gentoo|(support|hosting)@osuosl)\\.org|communication@magic\\.fr|(s(ales|upport)@7l|support@gossamerhost)\\.com|(support|buchhaltung)@manitu\\.de|support@((gt|inerail)\\.net|stepping-stone\\.ch)'
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
logs = gentoo_unseen:match_from('(g(archives|cvsd-rsync|infrastatus|web|mirror|qa|packages|planet|itolite)|root|apache|MAILER-DAEMON|nobody)@gentoo\\.org'):match_to('(root|gweb|infra-automated-retire|recruiters|planet)@gentoo\\.org') + gentoo_unseen:contain_from('root@osprey.gentoo.org'):contain_to('root') + gentoo_unseen:match_from('ipmi@b(ittern|obolink)\\.gentoo\\.oob') + gentoo_unseen:contain_to('root@gentoo.org'):match_subject('[*]{3} SECURITY information for [a-z]+ [*]{3}') + gentoo_unseen:contain_from('elections@gentoo.org'):contain_to('tampakrap@gentoo.org')
logs:move_messages(gentoo['logs'])
blogs = gentoo_unseen:contain_from('wordpress@blogs.gentoo.org')
myblog = blogs:contain_subject('[the purple greeko]')
myblog:move_messages(gentoo['logs/blog'])
blogs:move_messages(gentoo['logs'])
bugzilla = gentoo_unseen:contain_from('bugzilla-daemon@gentoo.org'):move_messages(gentoo['logs/bugzilla'])
gentoo_unseen:contain_to('cfengine@gentoo.org'):move_messages(gentoo['logs/cfengine'])
gentoo_unseen:match_from('(icinga@gentoo|nagios@osuosl)\\.org'):move_messages(gentoo['logs/icinga'])
github = gentoo_unseen:match_from('((noreply|support|notifications)@github|(notifications|builds)@travis-ci)\\.com') + gentoo_unseen:contain_from('X-GitHub-Recipient', 'tampakrap')
github:move_messages(gentoo['logs/github'])
gentoo_unseen:contain_to('infra-commits@gentoo.org'):move_messages(gentoo['logs/infra-commits'])
gentoo_unseen:contain_from('puppet@puppetmaster.gentoo.org'):move_messages(gentoo['logs/puppet'])
gentoo_unseen:match_from('donotreply@wordpress\\.com'):move_messages(gentoo['newsletters'])
