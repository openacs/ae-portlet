ad_page_contract {
    The display logic for the assessment admin portlet

    @author Anny Flores (annyflores@viaro.net)
    @author Viaro Networks (www.viaro.net)
    
} -properties {
    
}

array set config $cf
set user_id [ad_conn user_id]
set list_of_package_ids $config(package_id)
set dotlrn_admin_p [dotlrn::admin_p -user_id $user_id]

if {[llength $list_of_package_ids] > 1} {
    # We have a problem!
    return -code error "[_ assessment-portlet.error_one_assessment] "
}        

set package_id [lindex $list_of_package_ids 0]        

set url [lindex [site_node::get_url_from_object_id -object_id $package_id] 0]
set user_id [ad_conn user_id]
set package_admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege "admin"]
set actions "<a class=button href=[export_vars -base anon-eval/asm-admin/assessment-form]>[_ ae-portlet.New_Evaluation]</a>"

if { $package_admin_p == 0} {
    set m_name "get_all_assessments_admin"
} else {
    set m_name "get_all_assessments"
}

#list all assessments

db_multirow -extend { export permissions admin_request status edit_url sessions_url cvs_url status_url } assessments $m_name {} {
    set export "[_ assessment.Export]"
    set permissions "[_ assessment.permissions]"
    set admin_request "[_ assessment.Request] [_ assessment.Administration]"

    if { $live_revision eq "" } {
	set status "[_ ae-portlet.Publish]"
    } else {
	set status "[_ ae-portlet.Unpublish]"
    }

    set edit_url [export_vars -base anon-eval/asm-admin/assessment-form {assessment_id}]
    set sessions_url [export_vars -base anon-eval/sessions {assessment_id}]
    set cvs_url [export_vars -base anon-eval/asm-admin/results-export {assessment_id}]
    set status_url [export_vars -base anon-eval/asm-admin/toggle-status {assessment_id {return_url [ad_return_url]}}]
}

list::create \
    -name assessments \
    -key assessment_id \
    -no_data "[_ assessment.None]" \
    -elements {
	title {
	    label {[_ ae-portlet.title]}
	    display_template { <center><a href=[export_vars -base anon-eval/asm-admin/one-a { assessment_id }]>@assessments.title@</a></center>}
	}
	edit {
	    display_template {<a href="@assessments.edit_url;noquote@"><img border=0 src="/resources/Edit16.gif"></a>}
	}
	view_results  {
	    label {[_ ae-portlet.view_results]}
	    display_template {<a href="@assessments.sessions_url;noquote@">#assessment.All#</a> |
		<a href="@assessments.cvs_url;noquote@">#assessment.CSV_file#</a> |
		<a href="@assessments.status_url;noquote@">@assessments.status@</a></td>}
	    html { nowrap }
	}
    } 


ad_return_template 
