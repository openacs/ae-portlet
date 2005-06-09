ad_library {
    Procedures for initializing service contracts etc. for the
    anon-eval portlet package. Should only be executed 
    once upon installation.
    
    @author Anny Flores (annyflores@viaro.net)
    @author Viaro Networks (www.viaro.net)
}

namespace eval apm::ae_portlet {}
namespace eval apm::ae_admin_portlet {}

ad_proc -public apm::ae_portlet::after_install {} {
    Create the datasources needed by the anon-eval portlets.
} {
    ae_portlet::after_install
    ae_admin_portlet::after_install
}

ad_proc -public apm::anon-eval_portlet::before_uninstall {} {
    Anon-Eval Portlet package uninstall proc
} {
    
    db_transaction {
        ae_portlet::uninstall
        ae_admin_portlet::uninstall
    }
}


