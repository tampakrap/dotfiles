dofile("/home/tampakrap/.imapfilter/common.lua")

status, password = pipe_from('~/bin/getmailpass.py suse')
password = password.gsub(password, ' ', '').gsub(password, '\n', '')

suse = IMAP {
    server = 'imap.suse.de',
    username = 'tchatzimichos',
    password = password,
    ssl = 'tls1.3',
    port = 993,
}

suse_all = suse['INBOX']:select_all()
suse_new = suse['INBOX']:is_new()
suse_recent = suse['INBOX']:is_recent()
suse_unseen = suse['INBOX']:is_unseen()


get_domain = function (email_prefix, cz_emails_table)
    domain = 'de'
    for _,l in pairs(cz_emails_table) do
        if email_prefix == l then
            domain = 'cz'
            break
        end
    end
    return domain
end


opensuse_list = function (list_prefix)
    list = '^' .. list_prefix .. '@opensuse.org$'
    list_mine = suse_unseen:contain_from('tampakrap@opensuse.org')
    return suse_unseen:contain_field('X-Mailinglist', list_prefix) +
           suse_unseen:contain_to('tampakrap@opensuse.org'):contain_cc(list) +
           suse_unseen:contain_to('tampakrap@opensuse.org'):contain_to(list) +
           list_mine:contain_to(list) + list_mine:contain_cc(list) +
           suse_unseen:match_from(list_prefix .. '\\+(owner|help)@opensuse.org')
end


suse_list = function (list_prefix)
    list = list_prefix .. '@suse\\.' .. get_domain(list_prefix, {'cz', 'maso', 'ops', 'talk-cz'})
    return suse_unseen:match_field('X-BeenThere', '^' .. list .. '$')
end


infra_rt = function (to)
    domain = get_domain(to, {'prague'})
    return infra_rt_all:match_field('Reply-To', to .. '(-(messages|comment))?@suse\\.' .. domain) + suse_unseen:contain_from(to .. '@suse.' .. domain)
end


redmine_issues = function ()
    return redmine:match_field('X-Redmine-Issue-Id', '[0-9]{1,6}')
end


progress_issues = function ()
    return progress:match_field('X-Redmine-Issue-Id', '[0-9]{1,6}')
end


suse_unseen:match_field('X-Spam-Flag', 'YES'):move_messages(suse['Spam'])
opensuse_list('gsoc-mentors'):move_messages(suse['lists/opensuse/gsoc-mentors'])
opensuse_list('opensuse-announce'):move_messages(suse['lists/opensuse/opensuse-announce'])
opensuse_list('opensuse-cz'):move_messages(suse['lists/opensuse/opensuse-cz'])
opensuse_list('opensuse-el'):move_messages(suse['lists/opensuse/opensuse-el'])
opensuse_list('opensuse-factory'):move_messages(suse['lists/opensuse/opensuse-factory'])
opensuse_list('opensuse-project'):move_messages(suse['lists/opensuse/opensuse-project'])
opensuse_list('opensuse-security-announce'):move_messages(suse['lists/opensuse/opensuse-security-announce'])
opensuse_list('opensuse-security'):move_messages(suse['lists/opensuse/opensuse-security'])
opensuse_list('opensuse-updates'):move_messages(suse['lists/opensuse/opensuse-updates'])
suse_list('cz'):move_messages(suse['lists/suse/cz'])
suse_list('devel'):move_messages(suse['lists/suse/devel'])
suse_list('hackweek'):move_messages(suse['lists/suse/hackweek'])
suse_list('maso'):move_messages(suse['lists/suse/maso'])
suse_list('opensuse-internal'):move_messages(suse['lists/suse/opensuse-internal'])
suse_list('openvpn-info'):move_messages(suse['lists/suse/openvpn-info'])
suse_list('ops'):move_messages(suse['lists/suse/ops'])
infra = suse_list('ops-services')
infra_logs = opensuse_list('admin-auto') + infra:match_from('(netapp0[1-2]|rt-count)@suse\\.de|netapp0[5-6]@suse\\.cz|asupprod@netapp\\.com|ShipmentNotificationDVOnline@intel\\.com') + infra:match_to('rd-adm-svn@suse\\.de')
infra_logs:move_messages(suse['logs/infra'])
infra:contain_from('gitlab@opensuse.org'):move_messages(suse['logs/gitlab'])
infra_rt_all = infra:match_field('X-RT-Loop-Prevention', '(SUSE Ticket|RT-ADM)')
infra_rt('archticket'):move_messages(suse['logs/rt/arch'])
infra_rt('infra'):move_messages(suse['logs/rt/infra'])
infra_rt('openvpn'):move_messages(suse['logs/rt/openvpn'])
infra_rt('prague'):move_messages(suse['logs/rt/prague'])
infra_rt('s390ticket'):move_messages(suse['logs/rt/s390'])
infra_rt('system'):move_messages(suse['logs/rt/system'])
infra:move_messages(suse['lists/suse/ops-services'])
suse_list('research'):move_messages(suse['lists/suse/research'])
suse_list('results'):move_messages(suse['lists/suse/results'])
suse_list('talk-cz'):move_messages(suse['lists/suse/talk-cz'])
suse_list('users'):move_messages(suse['lists/suse/users'])
logs = suse_unseen:match_from('HelpDesk@attachmategroup.com|((istdirteam|GWAVA|webmaster|pwnotify)@|(psoft@(sybok|sarek)|WF-BATCH@eccprd1)\\.provo\\.)novell\\.com|(swamp|orthos)_noreply@suse\\.de|helpdesk@netiq\\.com|support@ovationincentives\\.com') + suse_unseen:match_from('maint-coord@(novell\\.com|suse\\.de)'):match_subject('Maintenance QA (SLA|KPI) watchdog report - [0-9]{8}')
logs:move_messages(suse['logs'])
suse_unseen:match_from('[Bb]ugzilla_[Nn]o[Rr]eply@novell\\.com'):match_to('tampakrap@opensuse\\.org|tchatzimichos@suse\\.c(om|z)'):move_messages(suse['logs/bugzilla'])
github = suse_unseen:match_from('((noreply|support|notifications)@github|(notifications|builds)@travis-ci)\\.com') + suse_unseen:contain_field('X-GitHub-Recipient', 'tampakrap')
github:move_messages(suse['logs/github'])
suse_unseen:match_from('gitlab@(opensuse\\.org|suse\\.de)'):move_messages(suse['logs/gitlab'])
ibs = suse_unseen:match_field('X-OBS-URL', 'https://build.suse.de')
ibs:match_field('X-OBS-event-type', 'build_.*'):move_messages(suse['logs/ibs/builds'])
ibs:match_field('X-OBS-event-type', 'comment_for_.*|request_.*'):move_messages(suse['logs/ibs/sr'])
suse_unseen:match_from('nagios@(novell\\.com|suse\\.cz)'):move_messages(suse['logs/nagios'])
obs = suse_unseen:match_field('X-OBS-URL', 'https://build.opensuse.org')
obs:match_field('X-OBS-event-type', 'build_.*'):move_messages(suse['logs/obs/builds'])
obs_sr = obs:match_field('X-OBS-event-type', 'comment_for_.*|request_.*') + suse_unseen:contain_from('coolo@suse.de'):contain_subject('Reminder for openSUSE:Factory work')
obs_sr:move_messages(suse['logs/obs/sr'])
redmine = suse_unseen:contain_from('redmine@suse.de')
redmine_issues():move_messages(suse['logs/redmine'])
redmine:move_messages(suse['logs'])
progress = suse_unseen:match_from('(admin|redmine)@opensuse\\.org')
progress_issues():match_field('X-Redmine-Project', '^opensuse-admin$'):move_messages(suse['logs/progress/opensuse-admin'])
progress_issues():match_field('X-Redmine-Project', '^opensuse-admin-puppet$'):move_messages(suse['logs/progress/puppet'])
progress_issues():move_messages(suse['logs/progress'])
progress:move_messages(suse['logs'])
suse_unseen:match_from('.*@rsm-tacoma.cz'):move_messages(suse['logs/rsm-tacoma'])
suse_unseen:match_to('DL-(Prague|TAG|SU|MicroFocusInternational)-(A[lL]{2}|EMPLOYEES|Employees|Office)(\\.iList\\.INTERNET)?@ilist\\.attachmategroup\\.com'):move_messages(suse['newsletters'])
