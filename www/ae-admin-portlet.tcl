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
set actions "<a class=button href=[export_vars -base anon-eval/asm-admin/assessment-form]>[_ assessment.New_Assessment]</a>"

if { $package_admin_p == 0} {
    set m_name "get_all_assessments_admin"
} else {
    set m_name "get_all_assessments"
}

#list all assessments

db_multirow -extend { export permissions admin_request} assessments $m_name {} {
    set export "[_ assessment.Export]"
    set permissions "[_ assessment.permissions]"
    set admin_request "[_ assessment.Request] [_ assessment.Administration]"
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
	    display_template {<a href="[export_vars -base anon-eval/asm-admin/assessment-form {assessment_id}]"><img border=0 src="/resources/Edit16.gif"></a>}
	}
	view_results  {
	    label {[_ ae-portlet.view_results]}
	    display_template {<a href=[export_vars -base anon-eval/sessions {assessment_id}]>#assessment.All#</a> |
		<a href=[export_vars -base anon-eval/asm-admin/results-export {assessment_id}]>#assessment.CSV_file#</a></td>}
	}
    } 


ad_return_template 
