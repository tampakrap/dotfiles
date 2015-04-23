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
    list = list_prefix .. '@opensuse.org'
    list_mine = suse_unseen:contain_from('tampakrap@opensuse.org')
    return suse_unseen:contain_field('X-Mailinglist', list_prefix) +
           suse_unseen:contain_to('tampakrap@opensuse.org'):contain_cc(list) +
           suse_unseen:contain_to('tampakrap@opensuse.org'):contain_to(list) +
           list_mine:contain_to(list) + list_mine:contain_cc(list) +
           suse_unseen:match_from(list_prefix .. '\\+(owner|help)@opensuse.org')
end


suse_list = function (list_prefix)
    list = list_prefix .. '@suse\\.' .. get_domain(list_prefix, {'cz', 'ops', 'talk-cz'})
    return suse_unseen:match_field('X-BeenThere', list)
end


infra_rt = function (to)
    domain = get_domain(to, {'prague'})
    return infra_rt_all:match_field('Reply-To', to .. '(-comment)?@suse\\.' .. domain) + suse_unseen:contain_from(to .. '@suse.' .. domain)
end


redmine_project = function (project)
    return suse_unseen:match_field('X-Redmine-Project', '^' .. project .. '$')
end


suse_unseen:match_field('X-Spam-Flag', 'YES'):move_messages(suse['Spam'])
opensuse_list('opensuse-announce'):move_messages(suse['lists/opensuse'])
opensuse_list('gsoc-mentors'):move_messages(suse['lists/opensuse/gsoc-mentors'])
opensuse_list('opensuse-cz'):move_messages(suse['lists/opensuse/opensuse-cz'])
opensuse_list('opensuse-el'):move_messages(suse['lists/opensuse/opensuse-el'])
suse_list('cloud'):move_messages(suse['lists/suse/cloud'])
suse_list('cloud-devel'):move_messages(suse['lists/suse/cloud-devel'])
suse_list('cz'):move_messages(suse['lists/suse/cz'])
suse_list('devel'):move_messages(suse['lists/suse/devel'])
suse_list('hackweek'):move_messages(suse['lists/suse/hackweek'])
suse_list('opensuse-internal'):move_messages(suse['lists/suse/opensuse-internal'])
suse_list('openvpn-info'):move_messages(suse['lists/suse/openvpn-info'])
suse_list('ops'):move_messages(suse['lists/suse/ops'])
infra = suse_list('ops-services')
infra_logs = infra:match_from('netapp01@suse\\.de') + infra:match_to('rd-adm-svn@suse.de')
infra_logs:move_messages(suse['logs/infra'])
infra_rt_all = infra:match_field('X-RT-Loop-Prevention', 'SUSE Ticket')
infra_rt('arch'):move_messages(suse['logs/rt/arch'])
infra_rt('infra'):move_messages(suse['logs/rt/infra'])
infra_rt('openvpn'):move_messages(suse['logs/rt/openvpn'])
infra_rt('prague'):move_messages(suse['logs/rt/prague'])
infra:move_messages(suse['lists/suse/ops-services'])
suse_list('patch-management'):move_messages(suse['lists/suse/patch-management'])
suse_list('qa-maintenance'):move_messages(suse['lists/suse/qa-maintenance'])
suse_list('qa-maintenance-dev'):move_messages(suse['lists/suse/qa-maintenance-dev'])
suse_list('qa-maintenance-reports'):move_messages(suse['lists/suse/qa-maintenance-reports'])
suse_list('qa-reports'):move_messages(suse['lists/suse/qa-reports'])
suse_list('qa-team'):move_messages(suse['lists/suse/qa-team'])
suse_list('research'):move_messages(suse['lists/suse/research'])
suse_list('results'):move_messages(suse['lists/suse/results'])
suse_list('studio-devel'):move_messages(suse['lists/suse/studio-devel'])
suse_list('talk-cz'):move_messages(suse['lists/suse/talk-cz'])
suse_list('users'):move_messages(suse['lists/suse/users'])
logs = suse_unseen:match_from('(istdirteam|GWAVA)@novell\\.com|orthos_noreply@suse\\.de|helpdesk@netiq\\.com') + suse_unseen:match_from('maint-coord@(novell\\.com|suse\\.de)'):match_subject('Maintenance QA (SLA|KPI) watchdog report - [0-9]{8}') + suse_unseen:contain_from('swamp_noreply@suse.de'):contain_to('tchatzimichos@suse.cz')
logs:move_messages(suse['logs'])
suse_unseen:match_from('[Bb]ugzilla_[Nn]o[Rr]eply@novell\\.com'):match_to('tampakrap@opensuse\\.org|tchatzimichos@suse\\.c(om|z)'):move_messages(suse['logs/bugzilla'])
github = suse_unseen:match_from('((noreply|support|notifications)@github|(notifications|builds)@travis-ci)\\.com') + suse_unseen:contain_field('X-GitHub-Recipient', 'tampakrap')
github:move_messages(suse['logs/github'])
suse_unseen:match_from('gitlab@(opensuse\\.org|suse\\.de)'):move_messages(suse['logs/gitlab'])
ibs = suse_unseen:match_field('X-OBS-URL', 'https://build.suse.de')
ibs:match_field('X-OBS-event-type', 'build_.*'):move_messages(suse['logs/ibs/builds'])
ibs:match_field('X-OBS-event-type', 'comment_for_.*|request_.*'):move_messages(suse['logs/ibs/sr'])
obs = suse_unseen:match_field('X-OBS-URL', 'https://build.opensuse.org')
obs:match_field('X-OBS-event-type', 'build_.*'):move_messages(suse['logs/obs/builds'])
obs_sr = obs:match_field('X-OBS-event-type', 'comment_for_.*|request_.*') + suse_unseen:contain_from('coolo@suse.de'):contain_subject('Reminder for openSUSE:Factory work')
obs_sr:move_messages(suse['logs/obs/sr'])
redmine_project('opensuse-admin'):move_messages(suse['logs/progress/opensuse-admin'])
redmine_project('opensuse-admin-puppet'):move_messages(suse['logs/progress/puppet'])
redmine_project('backup'):move_messages(suse['logs/redmine/backup'])
redmine_project('monitoring'):move_messages(suse['logs/redmine/monitoring'])
redmine_project('infra-prague'):move_messages(suse['logs/redmine/prague'])
redmine_project('security'):move_messages(suse['logs/redmine/security'])
redmine_project('virtualization'):move_messages(suse['logs/redmine/virtualization'])
redmine_project('voip'):move_messages(suse['logs/redmine/voip'])
suse_unseen:match_from('.*@rsm-tacoma.cz'):move_messages(suse['logs/rsm-tacoma'])
suse_unseen:match_to('DL-(Prague|TAG|SU|MicroFocusInternational)-(A[lL]{2}|EMPLOYEES|Employees|Office)(\\.iList\\.INTERNET)?@ilist\\.attachmategroup\\.com'):move_messages(suse['newsletters'])
