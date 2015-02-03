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
gmail_unseen:match_from('(accounts@oreilly|(invitation-)?do-not-reply@(trello|stack(exchange|overflow))|admin@transifex|reddit@reddit|no-reply@(dropbox|socghop\\.appspotmail|lanyrd|susestudio)|((d\\+MTA4MDQ2NTk2NjI3OTg3NjgyMjIw-.*@docs|no(-)?reply(@(accounts|checkout|cbg\\.bounces|wallet)|-.*@plus))\\.|(mail|drive)-noreply@)google|account-security-noreply@account\\.microsoft|notice-5622092@no-ip|gitlab@gitlab|ebay@ebay|(issue-updates|tickets|noreply|forge)@puppetlabs|notification\\+ka4k2g4a@facebookmail|(miles\\.bonus|echeckin|noreply|boardingpass)@aegeanair|service@(intl\\.paypal|payu)|webmaster@novell|mantis@public\\.kitware|support@olx|donotreply@(gravatar|wordpress)|alerts@citibank|notify@twitter|noreply((-www@services\\.|@)swiss|youtube)|(info@advisory\\.|itinerary@)ryanair|(bme@mailer\\.|customer\\.service@)booking)\\.com|(notify@keybase|support@drone)\\.io|(support@cacert|accounts@fedoraproject|donotreply@rubygems|noreply@(redmine|wordpress)|no-reply@(persona|mozillians))\\.org|(no_reply@gopay|robot@jidloted|noreply@c(sas|inemacity)|eshop_noreply@dpp|obchod@ticketportal|ticket@ticketpro|letenky@pelikan|reservation@previo)\\.cz|no-reply@jetpack\\.me|(no-reply@vodafonecu|info@flowernet|billing@ziz)\\.gr|(fahrkartenservice@bahn|(info@|puppetcamp\\.teilnehmer@rt\\.)netways)\\.de'):move_messages(gmail['logs'])
gmail_unseen:match_from('.*@bitbucket\\.org'):move_messages(gmail['logs/bitbucket'])
github = gmail_unseen:match_from('(noreply|support)@github\\.com|builds@travis-ci\\.org') + gmail_unseen:contain_field('X-GitHub-Recipient', 'tampakrap')
github:move_messages(gmail['logs/github'])
linkedin_all= gmail_unseen:match_from('.*@linkedin\\.com') + gmail_unseen:match_field('X-LinkedIn-Template', 'invite_guest_59|connection_suggestion_email')
linkedin = linkedin_all - linkedin_all:contain_field('X-LinkedIn-Class', 'INMAIL')
linkedin:move_messages(gmail['logs/linkedin'])
gmail_unseen:match_from('(noreply@(mailer\\.atlassian|bitlysupport)|oreilly@post\\.oreilly|contact@puppetlabs|(Miles(&|\\+)Bonus|newsletter)@email\\.aegeanair|no-reply@dropboxmail|linkedin@e\\.linkedin|Microsoft@e-mail\\.microsoft|(alerts7|noreply3)@emails\\.skype|(news|support)@gitlab(control)?|info@smartwings|eBay@reply1\\.ebay|update\\+ka4k2g4a@facebookmail|(privacy-noreply|ingress-support)@google|e(-info|vents)@suse|invite@eventbrite|alerts@lanyrd|paypal@e\\.paypal|taco@trello)\\.com|(newsletter@arbes(dent|plus)|mailing@pelikan|(stuff|noreply)@linuxdays|info@installfest|novinky@jidloted|(newsletter@info\\.|directmail@)csa)\\.cz|((career|cs-news|carseniou)@teilar|(support|info|no-reply)@(ziz|papaki)|Webmaster@Thelab|noreply@(gtvs|eurobank)|specials@flowernet|info@ellak|phplists-bounces@eellak)\\.gr|((noreply|sales)@mailer\\.bitbucket|admin@fedoraproject|(events|no-reply)@linuxfoundation)\\.org|noreply@hetzner-status\\.de'):move_messages(gmail['newsletters'])
gmail_unseen:match_from('(info@|vypis\\.citibank\\.cz@edelivery\\.)citi\\.com|obchodni\\.sdeleni@citiagent\\.cz'):move_messages(gmail['newsletters/citibank'])
gmail_unseen:contain_from('faktury@developtech.cz'):move_messages(gmail['newsletters/developtech'])
gmail_unseen:match_from('(fakturace|podzim)@pre\\.cz'):move_messages(gmail['newsletters/pre'])
