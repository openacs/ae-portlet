ad_library {

    Procedures to support the ae portlets

    
    @author Anny Flores (annyflores@viaro.net)
    @author Viaro Networks (www.viaro.net)

}

namespace eval ae_portlet {}
namespace eval ae_admin_portlet {}


#
# ae namespace
#

ad_proc -private ae_portlet::get_my_name {
} {
    return "ae_portlet"
}



ad_proc -private ae_portlet::my_package_key {
} {
    return "ae-portlet"
}

ad_proc -public ae_portlet::get_pretty_name {
} {
    return "#anon-eval.Anon_Eval#"
}



ad_proc -public ae_portlet::link {
} {
    return ""
}



ad_proc -public ae_portlet::add_self_to_page {
    {-portal_id:required}
    {-package_id:required}
    {-param_action:required}
    {-force_region ""}
    {-page_name "" }
} {
    Adds a ae PE to the given portal.
    
    @param portal_id The page to add self to
    @param package_id The community with the folder
    
    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -value $package_id \
                -force_region $force_region \
		-page_name $page_name \
                -pretty_name [get_pretty_name] \
                -param_action $param_action
           ]
}



ad_proc -public ae_portlet::remove_self_from_page {
    {-portal_id:required}
    {-package_id:required}
} {
    Removes a ae PE from the given page or the package_id of the
    ae package from the portlet if there are others remaining
    
    @param portal_id The page to remove self from
    @param package_id
} {
    portal::remove_element_parameters \
        -portal_id $portal_id \
        -portlet_name [get_my_name] \
        -value $package_id
}



ad_proc -public ae_portlet::show {
    cf
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "ae-portlet"
}

#
# ae admin namespace
#

ad_proc -private ae_admin_portlet::get_my_name {} {
    return "ae_admin_portlet"
}


ad_proc -public ae_admin_portlet::get_pretty_name {} {
    return "#anon-eval.Anon_Eval_Administration#"
}



ad_proc -private ae_admin_portlet::my_package_key {} {
    return "ae-portlet"
}



ad_proc -public ae_admin_portlet::link {} {
    return ""
}



ad_proc -public ae_admin_portlet::add_self_to_page {
    {-portal_id:required}
    {-page_name ""}
    {-package_id:required}
} {
    Adds a ae admin PE to the given portal

    @param portal_id The page to add self to
    @param package_id The package_id of the ae package

    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -key package_id \
                -value $package_id
           ]
}

ad_proc -public ae_admin_portlet::remove_self_from_page {
    {-portal_id:required}
} {
    Removes a ae admin PE from the given page
} {
    portal::remove_element \
        -portal_id $portal_id \
        -portlet_name [get_my_name]
}


ad_proc -public ae_admin_portlet::show {
    cf
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "ae-admin-portlet"
}

ad_proc -private ae_portlet::after_install {} {
    Create the datasources needed by the ae portlet.
} {
    
    db_transaction {
	set ds_id [portal::datasource::new \
		       -name "ae_portlet" \
		       -description "Anon Eval Portlet"]

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value t

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl

    }
}

ad_proc -private ae_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the ae portlet.
} {
    set spec {
        name "ae_portlet"
	contract_name "portal_datasource"
	owner "ae-portlet"
        aliases {
	    GetMyName ae_portlet::get_my_name
	    GetPrettyName  ae_portlet::get_pretty_name
	    Link ae_portlet::link
	    AddSelfToPage ae_portlet::add_self_to_page
	    Show ae_portlet::show
	    Edit ae_portlet::edit
	    RemoveSelfFromPage ae_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private ae_admin_portlet::after_install {} {
    Create the datasources needed by the ae portlet.
} {

    db_transaction {
	set ds_id [portal::datasource::new \
		       -name "ae_admin_portlet" \
		       -description "Ae Admin Portlet"]

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value f

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl
    }

}



ad_proc -private ae_admin_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the ae admin portlet.
} {
    set spec {
        name "ae_admin_portlet"
	contract_name "portal_datasource"
	owner "ae-portlet"
        aliases {
	    GetMyName ae_admin_portlet::get_my_name
	    GetPrettyName  ae_admin_portlet::get_pretty_name
	    Link ae_admin_portlet::link
	    AddSelfToPage ae_admin_portlet::add_self_to_page
	    Show ae_admin_portlet::show
	    Edit ae_admin_portlet::edit
	    RemoveSelfFromPage ae_admin_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private ae_portlet::uninstall {} {
    Ae Portlet package uninstall proc
} {
    unregister_implementations
    set ds_id [portal::get_datasource_id ae_portlet]
    db_exec_plsql delete_aes_ds { *SQL* }
}

ad_proc -private ae_admin_portlet::uninstall {} {
    Ae Portlet package uninstall proc
} {
    unregister_implementations
    set ds_id [portal::get_datasource_id ae_admin_portlet]
    db_exec_plsql delete_admin_ds { *SQL* }
}

ad_proc -private ae_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "ae_portlet"
}

ad_proc -private ae_admin_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "ae_admin_portlet"
}
