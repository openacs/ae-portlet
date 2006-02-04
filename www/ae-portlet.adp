<if @shaded_p@ false>
  <listtemplate name="assessments"></listtemplate>
  <if @package_admin_p@ and @community_id@ ne "">
    <p />
    <br />
    #ae-portlet.lt_NOTE_This_is_an_admin#
    <p />
    <listtemplate name="unpublished_assessments"></listtemplate>
  </if>
</if>
<else>
  &nbsp;
</else>
