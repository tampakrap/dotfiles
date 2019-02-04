dofile("/home/tampakrap/.imapfilter/common.lua")

status, password = pipe_from('~/bin/getmailpass.py gmail')
password = password.gsub(password, ' ', '').gsub(password, '\n', '')

gmail = IMAP {
    server = 'imap.gmail.com',
    username = 'tampakrap',
    password = password,
    ssl = 'tls1.3',
    port = 993,
}

gmail_all = gmail['INBOX']:select_all()
gmail_new = gmail['INBOX']:is_new()
gmail_recent = gmail['INBOX']:is_recent()
gmail_unseen = gmail['INBOX']:is_unseen()

gmail_unseen:match_field('X-BeenThere', 'announce@linuxdays\\.cz'):move_messages(gmail['lists/linuxdays/announce'])
gmail_unseen:match_field('X-BeenThere', 'talk@linuxdays\\.cz'):move_messages(gmail['lists/linuxdays/talk'])
gmail_unseen:match_field('List-Id', 'voxpupuli\\.groups\\.io'):move_messages(gmail['lists/voxpupuli'])
gmail_unseen:match_from('(accounts@oreilly|(invitation-)?do-not-reply@(trello|stack(exchange|overflow))|(admin|notifications)@transifex|reddit@reddit|no-reply@(dropbox|socghop\\.appspotmail|lanyrd|susestudio|gitlab\\.uservoice)|((no-reply@accounts|noreply-9645285f@plus)\\.|((drive|payments|googleplay)-)?noreply(-maps-timeline)?@)google|account-security-noreply@account\\.microsoft|notice-5622092@no-ip|gitlab@(mg\\.)?gitlab|ebay@ebay|(issue-updates|tickets|noreply|forge)@puppetlabs|(noreply|notification\\+ka4k2g4a|security)@facebookmail|(miles\\.bonus|echeckin|no(-)?reply|boardingpass|notifications)@aegeanair|(paypal|service)@((intl|mail)\\.paypal|payu)|webmaster@novell|mantis@public\\.kitware|support@olx|donotreply@gravatar|(passwordhelp|donotreply)@wordpress|alerts@citibank|(verify|notify|password)@twitter|noreply(-www@services\\.|@(notifications\\.)?)swiss|youtube|(info@advisory\\.|itinerary@)ryanair|(bme@mailer\\.|customer\\.service@)booking|prague_harfa_(admin|msm)@jatomi|info@opprtunity|sklep@5zywiolow|issue-updates\\+[a-zA-Z]+@puppet|info@myopportunity|orders@eventbrite|service@liftago|(bookings@email\\.|donotreply@)easy[jJ]et|hello@genius|Do_Not_Reply@innovativexams|noreply@bandcamp|(noreply|support)@indiegogo|info@meetup|do-not-reply@imdb|(noreply|ordermessages)@discogs|no-reply@discogslabs|no-reply@spotify|info@vinylsalvation|accounts@wire|(express|invitation)@airbnb|support@vinyl-digital|noreply-account@xiaomi|(no-reply|feedback)@slack|ibcom\\.webmaster1@iberia|(American(\\.|_)Airlines@|no-reply@notify\\.email\\.)aa|mailer@doodle|(no-reply@|support@support\\.)digitalocean|(no(-)?reply|no-reply-aws|account-update)@amazon|no-reply@mail\\.instagram|no-reply@cc\\.yahoo-inc|noreply@gls-czech|do-not-reply@certmetrics|no-reply@psiexams|unimerch@umusic|notifications@fundrazr|rating-noreply@trustedshops|noreply@mixcloudmail|Onlinefrankierung.de@dhl|no-reply@notify.docker|info@papaki|ticketrestaurantcard-cz@edenred)\\.com|(notify@keybase|support@drone|(info|support)@virt|noreply@groups|noreply@ihaveit)\\.io|(support@cacert|accounts@fedoraproject|donotreply@rubygems|noreply@(redmine|wordpress)|no-reply@(persona|mozillians)|.*@bitbucket|bugzilla_noreply@kde|(do-not-reply|noreply|certification)@linuxfoundation|root@freeko)\\.org|((gopay|no[_-]reply)@gopay|zakaznici@damejidlo|noreply@c(sas|inemacity)|eshop_noreply@dpp|obchod@ticketportal|ticket@ticketpro|letenky@pelikan|reservation@previo|express@studentagency|(mailer|info)@goout|info@rb|noreply@linuxdays|info@boardstar|(info|hodnoceni)@regiojet|gpwebpay@b2b\\.gpe|no(-|_)?reply@ticketstream|ceskaposta@cpost|info@spalena53|noreply@pandaticket|support@endisc|(naminutku@info\\.|sluzebnicek@)alza|(info|moje)@rondo)\\.cz|no-reply@jetpack\\.me|((no-reply|info)@vodafonecu|info@flowernet|billing@ziz|(billing|info|support)@papaki|hmaster-info@ics\\.forth|paycenter@piraeusbank|sales@astra-airlines)\\.gr|((fahrkartenservice|buchungsbestaetigung|verspaetungsalarm)@bahn|(info@|puppetcamp\\.teilnehmer@rt\\.)netways|service@hhv|noreply@dhl|noreply@hermes-europe|no-reply@deutschepost|(auto-confirm|bestellbestaetigung|versandbestaetigung|promotion5)@amazon|noreply@paketankuendigung\\.myhermes)\\.de|(ipv6@he|invite@brandedme|(info|mailer)@goout)\\.net|(invitations|noreply)@angel\\.co|info@myopportunity.email'):move_messages(gmail['logs'])
gmail_unseen:match_from('(root|puppet|MAILER-DAEMON)@forkbomb\\.gr|support@hetzner\\.de'):move_messages(gmail['logs/forkbomb'])
gmail_unseen:match_to('(root|postmaster)@forkbomb\\.gr'):move_messages(gmail['logs/forkbomb'])
github = gmail_unseen:match_from('(noreply|support|notifications)@github\\.com|(notifications|builds)@travis-ci\\.org') + gmail_unseen:contain_field('X-GitHub-Recipient', 'tampakrap')
github:move_messages(gmail['logs/github'])
linkedin_all= gmail_unseen:match_from('.*@linkedin\\.com') + gmail_unseen:match_field('X-LinkedIn-Template', 'invite_guest_59|connection_suggestion_email')
linkedin = linkedin_all - linkedin_all:contain_field('X-LinkedIn-Class', 'INMAIL')
linkedin:move_messages(gmail['logs/linkedin'])
gmail_unseen:match_from('(noreply@(mailer\\.atlassian|bitlysupport)|oreilly@post\\.oreilly|contact@puppetlabs|((Miles(&|\\+)Bonus|newsletter)@email|newsletter@fly)\\.aegeanair|no-reply@dropboxmail|linkedin@e\\.linkedin|((Feedback|Microsoft)@e-mail|email@microsoft|msa@communication)\\.microsoft|(alerts(7)?|noreply3)@email(s)?\\.skype|(news|support|noreply|sytse|contact|community|securityalerts|webcasts)@gitlab(control)?|info@smartwings|eBay@reply1\\.ebay|update\\+ka4k2g4a@facebookmail|(privacy-noreply@policies\\.|ingress-support@)google|e(-info|vents)@suse|invite@eventbrite|alerts@lanyrd|paypal@e\\.paypal|taco@trello|support@transifex|czech@jatomi|subscribe@saltstack|notices@slashdotmedia|unic\\.greece@gmail|krystof\\.raska@liftago|betka@liftago.intercom-mail|info@twitter|generationeasyJet@email\\.easyJet|new(s)?@360training|-announce@meetup|((americanairlines@aadvantage|aavacations@aavacations)\\.email|(aavacations|loyalty|aavprogram)@loyalty\\.ms)\\.aa|aaron@doodle|aws-marketing-email-replies@amazon|newsletter@belowsystem|newsletter@getyourguide|iberiaplus@comunicaciones\\.iberia|info@news\\.broadway|office@wegrowwax|social@kartelmusicgroup|jess.thompson@discogs-labs.intercom-mail|((no-reply|privacy)@info|product@news)\\.digitalocean|((do-not-reply|dockercon|privacy|goto|partners)@|docker@info\\.)docker|info@mellomusicgroup|new@applemusic)\\.com|(newsletter@arbes(dent|plus)|(mailing|newsletter)@pelikan|announce@linuxdays|info@installfest|novinky@jidloted|(newsletter@info\\.|directmail@)csa|newsletter@clubcard|newsletter@news\\.cinemacity|mamhlad@damejidlo|jaromir@musicbar|potravinyonline@itesco|info@newsletter\\.ticketportal|info_servis@rb|bus@regiojetnews|info@news\\.kytary|info@news\\.profi-dj|novinky@bb|webinfo@info\\.alza|newsletter@billa|simon@rockcafe)\\.cz|((career|cs-news|carseniou)@teilar|(support|info|no-reply)@ziz|[Ww]ebmaster@[Tt]helab|noreply@gtvs|(noreply|Estatements)@eurobank|[Ii]nfo@((e)?[Ss]tate\\.)?e[Mm]ail\\.[Ee]urobank-[Cc]ommunication|specials@flowernet|info@ellak|phplist-bounces@eellak|(hello|newsletter)@airtickets|(ticket)?offers@viva)\\.[Gg]r|((noreply|sales)@mailer\\.bitbucket|admin@fedoraproject|(events|no-reply)@linuxfoundation|(action|editor|membership)@eff)\\.org|(noreply@hetzner-status|news@netways|(newsletter@|postmaster@reply\\.)hhv)\\.de|(newsletter@linuxcounter|info@next-episode)\\.net|do-not-reply@stackoverflow\\.email|[Nn]oah_[Cc]in@ihaveit\\.io|twitch@sfmarketing.twitch\\.tv'):move_messages(gmail['newsletters'])
gmail_unseen:contain_from('faktury@developtech.cz'):move_messages(gmail['newsletters/developtech'])
gmail_unseen:match_from('(fakturace|podzim|kampan)@pre\\.cz'):move_messages(gmail['newsletters/pre'])
