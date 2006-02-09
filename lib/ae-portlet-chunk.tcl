# packages/ae-portlet/lib/ae-portlet-chunk.tcl
#
# Anonymous evaluations
#
# @author Roel Canicula (roel@solutiongrove.com)
# @creation-date 2006-02-04
# @arch-tag: f64c2881-4fe2-4fb6-998e-18f660ab5f8c
# @cvs-id $Id$

foreach required_param {list_of_package_ids} {
    if {![info exists $required_param]} {
	return -code error "$required_param is a required parameter."
    }
}
foreach optional_param {} {
    if {![info exists $optional_param]} {
	set $optional_param {}
    }
}

set user_id [ad_conn user_id]
set dotlrn_admin_p [dotlrn::admin_p -user_id $user_id]

set community_id [dotlrn_community::get_community_id]

set groupby community_name

if { $community_id eq "" } {
    set groupby_list {
	label "[_ ae-portlet.Class]"
	type multivar
	values { { "[_ ae-portlet.Class]" { {groupby community_name} } } }
    }
} else {
    set groupby_list [list]
}

template::list::create \
    -name assessments \
    -multirow assessments \
    -page_flush_p 1 \
    -html { width 100% } \
    -no_data "#ae-portlet.lt_No_evaluations_presen#" \
    -elements {
	title {
	    label ""
	    display_template {
		<if @assessments.session_id@ ne "" or @assessments.over_p@>
		@assessments.title@
		</if>
		<else>
		<a href="@assessments.assessment_url;noquote@">@assessments.title@</a>
		</else>		    		
	    }
	}
	actions {
	    label ""
	    display_template {
		<if @assessments.session_id@ ne "">

		<if @assessments.completed_datetime@ eq "">
		<a href="@assessments.assessment_url;noquote@">#ae-portlet.Finish_Evaluation#</a>
		</if>
		<else>
		<a href="@assessments.view_url;noquote@"><img border=0 src=/resources/Zoom16.gif> #ae-portlet.View_Your_Response#</a>
		</else>

		</if>
		<else>
		
		<if @assessments.over_p@>
		[_ ae-portlet.lt_Sorry_this_evaluation]
		<if @assessments.package_admin_p@ eq 1>
		<a href="@assessments.assessment_url;noquote@">#ae-portlet.Take_Evaluation#</a>
                </if>
		</if>
		<else>
		<a href="@assessments.assessment_url;noquote@">[_ ae-portlet.Test_Evaluation]</a>
		</else>

		</else>		    
		<br />#ae-portlet.Anonymous# <if @assessments.package_admin_p@><if @assessments.anonymous_p@ eq "f"><a href="@assessments.anonymous_url;noquote@">#assessment.yes#</a>/<b>#assessment.no#</b></if><else><b>#assessment.yes#</b>/<a href="@assessments.anonymous_url;noquote@">#assessment.no#</a></else>
		</if><else><if @assessments.anonymous_p@ eq "f"><b>#assessment.no#</b></if><else><b>#assessment.yes#</b></else></else>
		<if @assessments.package_admin_p@>
		| <a href="@assessments.status_url;noquote@">#ae-portlet.Unpublish#</a> | <a href="@assessments.edit_url;noquote@">#ae-portlet.Edit_Evaluation#</a> | <a href="@assessments.results_url;noquote@">#ae-portlet.Results#</a>
		</if>
	    }
	}
    } \
    -groupby $groupby_list

set status_clause "and not ci.live_revision is null"
db_multirow -extend { edit_response_url view_url edit_url assessment_url status_url anonymous_url edit_url results_url package_admin_p over_p } assessments answered_assessments {} {

    set base_url [site_node::get_url_from_object_id -object_id $package_id]
    set package_admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege "admin"]

    set assessment_url [export_vars -base ${base_url}assessment { assessment_id }]
    set edit_response_url [export_vars -base ${base_url}assessment { assessment_id session_id }]
    set view_url [export_vars -base ${base_url}session { assessment_id session_id }]
    set status_url [export_vars -base ${base_url}asm-admin/toggle-status { assessment_id {return_url [ad_return_url]} }]
    set anonymous_url [export_vars -base ${base_url}asm-admin/toggle-anonymous { {assessment_id $assessment_rev_id} {return_url [ad_return_url]} }]

    set edit_url [export_vars -base ${base_url}asm-admin/one-a { assessment_id }]
    set results_url [export_vars -base ${base_url}sessions { assessment_id }]

    if {(![empty_string_p $start_time] && $start_time > $cur_time) || (![empty_string_p $end_time] && $end_time < $cur_time)} {
	set over_p 1
    } else {
	set over_p 0
    }
}

if { $community_id ne "" } {
    set package_id [dotlrn_community::get_package_id $community_id]
    set package_admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege "admin"]
    if { $package_admin_p } {
	set base_url "[site_node::get_url_from_object_id -object_id $package_id]anon-eval/"

	template::list::create \
	    -name unpublished_assessments \
	    -multirow unpublished_assessments \
	    -page_flush_p 1 \
	    -html { width 100% } \
	    -pass_properties { package_admin_p } \
	    -actions [list "[_ ae-portlet.New_Evaluation]" ${base_url}asm-admin/assessment-form "[_ ae-portlet.New_Evaluation]"] \
	    -no_data "[_ ae-portlet.lt_No_unpublished_evalua]" \
	    -elements {
		title {
		    label ""
		    link_url_col assessment_url
		}
		actions {
		    label ""
		    display_template {
			#ae-portlet.Anonymous# <if @unpublished_assessments.anonymous_p@ eq "f"><a href="@unpublished_assessments.anonymous_url;noquote@">#assessment.yes#</a>/<b>#assessment.no#</b></if><else><b>#assessment.yes#</b>/<a href="@unpublished_assessments.anonymous_url;noquote@">#assessment.no#</a></else> | <a href="@unpublished_assessments.status_url;noquote@">#ae-portlet.Publish#</a> | <a href="@unpublished_assessments.edit_url;noquote@">#ae-portlet.Edit_Evaluation#</a> | <a href="@unpublished_assessments.results_url;noquote@">#ae-portlet.Results#</a>
		    }
		}
	    }

	set status_clause "and ci.live_revision is null"
	db_multirow -extend { edit_url assessment_url status_url anonymous_url edit_url results_url } unpublished_assessments answered_assessments {} {
	    set assessment_url [export_vars -base ${base_url}assessment { assessment_id }]
	    set status_url [export_vars -base ${base_url}asm-admin/toggle-status { assessment_id {return_url [ad_return_url]} }]
	    set anonymous_url [export_vars -base ${base_url}asm-admin/toggle-anonymous { {assessment_id $assessment_rev_id} {return_url [ad_return_url]} }]

	    set edit_url [export_vars -base ${base_url}asm-admin/assessment-form { assessment_id }]
	    set results_url [export_vars -base ${base_url}sessions { assessment_id }]
	}
    }
}