ad_page_contract {
    The display logic for the assessment portlet
    
    @author Anny Flores (annyflores@viaro.net)
    @author Viaro Networks (www.viaro.net)
} {
    {page_num 0}
} -properties {
}

set user_id [ad_conn user_id]

array set config $cf	
set shaded_p $config(shaded_p)

set list_of_package_ids $config(package_id)
set package_id [lindex $list_of_package_ids 0]        
set user_id [ad_conn user_id]
set package_admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege "admin"]
set dotlrn_admin_p [dotlrn::admin_p -user_id $user_id]

set one_instance_p [ad_decode [llength $list_of_package_ids] 1 1 0]

set elements [list]
if {!$one_instance_p} {
    set elements [list community_name \
		      [list \
			   label "[_ dotlrn.Community]" \
			   display_template {<if @assessments.community_name@ not nil>@assessments.community_name@</if><else>&nbsp;</else>}]]
}

lappend elements title \
    [list \
	 label "[_ assessment.open_assessments]" \
	 display_template {<a href="@assessments.assessment_url@">@assessments.title@</a>}]


# create a list with all open assessments
template::list::create \
    -name assessments \
    -multirow assessments \
    -key assessment_id \
    -elements $elements \
    -main_class narrow

# get the information of all open assessments
template::multirow create assessments assessment_id title description assessment_url community_url community_name
set old_comm_node_id 0
db_foreach open_asssessments {} {
    if {([empty_string_p $start_time] || $start_time <= $cur_time) && ([empty_string_p $end_time] || $end_time >= $cur_time)} {
	if {$comm_node_id == $old_comm_node_id} {
	    set community_name ""
	}
	set community_url [site_node::get_url -node_id $comm_node_id]
	set assessment_url [site_node::get_url -node_id $as_node_id]
	set old_comm_node_id $comm_node_id

	if {[empty_string_p $password]} {
	    append assessment_url [export_vars -base "assessment" {assessment_id}]
	} else {
	    append assessment_url [export_vars -base "assessment-password" {assessment_id}]
	}

	template::multirow append assessments $assessment_id $title $description $assessment_url $community_url $community_name
    }
}


set elements [list]
if {!$one_instance_p} {
    set elements [list community_name \
		      [list \
			   label "[_ dotlrn.Community]" \
			   display_template {<if @sessions.community_name@ not nil>@sessions.community_name@</if><else>&nbsp;</else>}]]
}

lappend elements title \
    [list \
	 label "[_ assessment.Assessments]"] \

lappend elements edit\
    [list \
	  display_template {<center><a href=anon-eval/assessment?assessment_id=@sessions.assessment_id@&session_id=@sessions.session_id@><img border=0 src=/resources/Edit16.gif></a></center>}
    ]

lappend elements view \
    [list \
	 display_template {<center><a href=anon-eval/session?assessment=@sessions.assessment_id@&session_id=@sessions.session_id@><img border=0 src=/resources/Zoom16.gif></a></center>}
    ]

# create a list with all answered assessments and their sessions
template::list::create \
    -name sessions \
    -multirow sessions \
    -key assessment_id \
    -elements $elements \
    -main_class narrow

# get the information of all assessments store in the database
set old_comm_node_id 0
db_multirow -extend { session_id session_url community_url } sessions answered_assessments {} {
    if {$comm_node_id == $old_comm_node_id} {
	set community_name ""
    }
    as::assessment::data -assessment_id $assessment_id
    set assessment_rev_id $assessment_data(assessment_rev_id)
    set session_id [db_string last_session {select max(session_id) as session_id from as_sessions where assessment_id = :assessment_rev_id  and subject_id = :user_id}]

    set community_url [site_node::get_url -node_id $comm_node_id]
    set session_url "[site_node::get_url -node_id $as_node_id][export_vars -base sessions {assessment_id}]"
    set old_comm_node_id $comm_node_id
}
