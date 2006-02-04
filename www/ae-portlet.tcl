ad_page_contract {
    The display logic for the assessment portlet
    
    @author Anny Flores (annyflores@viaro.net)
    @author Viaro Networks (www.viaro.net)
} {
    {page_num 0}
} -properties {
}


array set config $cf	
set shaded_p $config(shaded_p)

set list_of_package_ids $config(package_id)