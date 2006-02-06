  <listtemplate name="assessments"></listtemplate>
  <if @package_admin_p@ defined and @package_admin_p@ eq 1 and @community_id@ ne "">
    <p />
    <br />
    #ae-portlet.lt_NOTE_This_is_an_admin#
    <p />
    <listtemplate name="unpublished_assessments"></listtemplate>
  </if>