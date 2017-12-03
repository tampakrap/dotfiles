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

gmail_unseen:match_field('X-BeenThere', '(google-summer-of-code|gsoc-mentors)-announce@googlegroups\\.com'):move_messages(gmail['lists/gsoc'])
gmail_unseen:match_field('X-BeenThere', 'puppet-announce@googlegroups\\.com'):move_messages(gmail['lists/puppet-announce'])
gmail_unseen:match_field('X-BeenThere', 'puppet-security-announce@googlegroups\\.com'):move_messages(gmail['lists/puppet-security-announce'])
gmail_unseen:match_field('X-BeenThere', 'salt-announce@googlegroups\\.com'):move_messages(gmail['lists/salt-announce'])
gmail_unseen:match_field('X-BeenThere', 'salt-packagers@googlegroups\\.com'):move_messages(gmail['lists/salt-packagers'])
gmail_unseen:match_field('X-BeenThere', 'announce@linuxdays\\.cz'):move_messages(gmail['lists/linuxdays/announce'])
gmail_unseen:match_field('X-BeenThere', 'talk@linuxdays\\.cz'):move_messages(gmail['lists/linuxdays/talk'])
gmail_unseen:match_field('List-Id', 'voxpupuli\\.groups\\.io'):move_messages(gmail['lists/voxpupuli'])
gmail_unseen:match_from('(accounts@oreilly|(invitation-)?do-not-reply@(trello|stack(exchange|overflow))|(admin|notifications)@transifex|reddit@reddit|no-reply@(dropbox|socghop\\.appspotmail|lanyrd|susestudio|gitlab\\.uservoice)|((no-reply@accounts|noreply-9645285f@plus)\\.|((drive|payments|googleplay)-)?noreply@)google|account-security-noreply@account\\.microsoft|notice-5622092@no-ip|gitlab@(mg\\.)?gitlab|ebay@ebay|(issue-updates|tickets|noreply|forge)@puppetlabs|(noreply|notification\\+ka4k2g4a|security)@facebookmail|(miles\\.bonus|echeckin|noreply|boardingpass)@aegeanair|(paypal|service)@((intl|mail)\\.paypal|payu)|webmaster@novell|mantis@public\\.kitware|support@olx|donotreply@gravatar|(passwordhelp|donotreply)@wordpress|alerts@citibank|(verify|notify)@twitter|noreply(-www@services\\.|@(notifications\\.)?)swiss|youtube|(info@advisory\\.|itinerary@)ryanair|(bme@mailer\\.|customer\\.service@)booking|prague_harfa_(admin|msm)@jatomi|info@opprtunity|sklep@5zywiolow|issue-updates\\+[a-zA-Z]+@puppet|info@myopportunity|orders@eventbrite|service@liftago|(bookings@email\\.|donotreply@)easy[jJ]et|hello@genius|Do_Not_Reply@innovativexams|noreply@bandcamp|(noreply|support)@indiegogo|info@meetup|do-not-reply@imdb|noreply@discogs|no-reply@spotify|info@vinylsalvation|accounts@wire|(express|invitation)@airbnb)\\.com|(notify@keybase|support@drone|support@virt|noreply@groups)\\.io|(support@cacert|accounts@fedoraproject|donotreply@rubygems|noreply@(redmine|wordpress)|no-reply@(persona|mozillians)|.*@bitbucket|bugzilla_noreply@kde|(do-not-reply|noreply|certification)@linuxfoundation)\\.org|((gopay|no_reply)@gopay|(info|robot)@jidloted|zakaznici@damejidlo|noreply@c(sas|inemacity)|eshop_noreply@dpp|obchod@ticketportal|ticket@ticketpro|letenky@pelikan|reservation@previo|express@studentagency|(mailer|info)@goout|info@rb|noreply@linuxdays|info@boardstar|(info|hodnoceni)@regiojet|gpwebpay@b2b\\.gpe|no-reply@ticketstream)\\.cz|no-reply@jetpack\\.me|(no-reply@vodafonecu|info@flowernet|billing@ziz|(billing|info|support)@papaki|hmaster-info@ics\\.forth|paycenter@piraeusbank|sales@astra-airlines)\\.gr|((fahrkartenservice|buchungsbestaetigung|verspaetungsalarm)@bahn|(info@|puppetcamp\\.teilnehmer@rt\\.)netways)\\.de|(ipv6@he|invite@brandedme|(info|mailer)@goout)\\.net|(invitations|noreply)@angel\\.co|info@myopportunity.email'):move_messages(gmail['logs'])
fbs = gmail_unseen:match_field('X-OBS-URL', 'https://build.freeko.org')
fbs:match_field('X-OBS-event-type', 'build_.*'):move_messages(gmail['logs/fbs/builds'])
fbs:match_field('X-OBS-event-type', 'comment_for_.*|request_.*|review_.*'):move_messages(gmail['logs/fbs/sr'])
gmail_unseen:match_from('(root|puppet|MAILER-DAEMON)@forkbomb\\.gr|support@hetzner\\.de'):move_messages(gmail['logs/forkbomb'])
gmail_unseen:match_from('gitlab@forkbomb\\.gr'):move_messages(gmail['logs/forkbomb/gitlab'])
gmail_unseen:match_to('(root|postmaster)@forkbomb\\.gr'):move_messages(gmail['logs/forkbomb'])
github = gmail_unseen:match_from('(noreply|support|notifications)@github\\.com|(notifications|builds)@travis-ci\\.org') + gmail_unseen:contain_field('X-GitHub-Recipient', 'tampakrap')
github:move_messages(gmail['logs/github'])
linkedin_all= gmail_unseen:match_from('.*@linkedin\\.com') + gmail_unseen:match_field('X-LinkedIn-Template', 'invite_guest_59|connection_suggestion_email')
linkedin = linkedin_all - linkedin_all:contain_field('X-LinkedIn-Class', 'INMAIL')
linkedin:move_messages(gmail['logs/linkedin'])
gmail_unseen:match_from('(noreply@(mailer\\.atlassian|bitlysupport)|oreilly@post\\.oreilly|contact@puppetlabs|(Miles(&|\\+)Bonus|newsletter)@email\\.aegeanair|no-reply@dropboxmail|linkedin@e\\.linkedin|((Feedback|Microsoft)@e-mail|email@microsoft|msa@communication)\\.microsoft|(alerts(7)?|noreply3)@email(s)?\\.skype|(news|support|noreply|sytse|contact|community)@gitlab(control)?|info@smartwings|eBay@reply1\\.ebay|update\\+ka4k2g4a@facebookmail|(privacy-noreply|ingress-support)@google|e(-info|vents)@suse|invite@eventbrite|alerts@lanyrd|paypal@e\\.paypal|taco@trello|support@transifex|czech@jatomi|subscribe@saltstack|notices@slashdotmedia|unic.greece@gmail|krystof\\.raska@liftago|betka@liftago.intercom-mail|info@twitter|generationeasyJet@email\\.easyJet|new(s)?@360training|-announce@meetup)\\.com|(newsletter@arbes(dent|plus)|(mailing|newsletter)@pelikan|announce@linuxdays|info@installfest|novinky@jidloted|(newsletter@info\\.|directmail@)csa|newsletter@clubcard|newsletter@news\\.cinemacity|mamhlad@damejidlo|jaromir@musicbar|potravinyonline@itesco|info@newsletter\\.ticketportal|info_servis@rb)\\.cz|((career|cs-news|carseniou)@teilar|(support|info|no-reply)@ziz|[Ww]ebmaster@[Tt]helab|noreply@gtvs|(noreply|Estatements)@eurobank|info@email.eurobank-communication|specials@flowernet|info@ellak|phplist-bounces@eellak|(hello|newsletter)@airtickets)\\.gr|((noreply|sales)@mailer\\.bitbucket|admin@fedoraproject|(events|no-reply)@linuxfoundation)\\.org|(noreply@hetzner-status|news@netways)\\.de|newsletter@linuxcounter\\.net'):move_messages(gmail['newsletters'])
gmail_unseen:contain_from('faktury@developtech.cz'):move_messages(gmail['newsletters/developtech'])
gmail_unseen:match_from('(fakturace|podzim)@pre\\.cz'):move_messages(gmail['newsletters/pre'])
