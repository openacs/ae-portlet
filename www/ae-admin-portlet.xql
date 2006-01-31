<?xml version="1.0"?>
<queryset>

<fullquery name="get_all_assessments">
      <querytext>
      
    select ci.item_id as assessment_id, coalesce(cr2.title, cr.title) as title, ci.live_revision, ci.latest_revision
    from cr_folders cf, cr_items ci
    left join cr_revisions cr
    on (cr.revision_id = ci.latest_revision)
    left join cr_revisions cr2
    on (cr2.revision_id = ci.live_revision), as_assessments a
    where a.assessment_id = cr.revision_id
    and ci.parent_id = cf.folder_id and cf.package_id = :package_id
    order by cr.title
    
      </querytext>
</fullquery>


<fullquery name="get_all_assessments_admin">
      <querytext>
    select ci.item_id as assessment_id, coalesce(cr2.title, cr.title) as title, ci.live_revision, ci.latest_revision
    from cr_folders cf, cr_items ci 
    left join cr_revisions cr
    on (cr.revision_id = ci.latest_revision)
    left join cr_revisions cr2
    on (cr2.revision_id = ci.live_revision), as_assessments a
    where a.assessment_id = cr.revision_id
    and ci.parent_id = cf.folder_id
    and  ci.item_id in (select object_id from acs_permissions where 
    grantee_id=:user_id and privilege='admin') and cf.package_id = :package_id
    order by cr.title
    
      </querytext>
</fullquery>

 
</queryset>
