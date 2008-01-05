{* 
TestLink Open Source Project - http://testlink.sourceforge.net/
$Id: execSetResults.tpl,v 1.9 2008/01/05 17:50:47 franciscom Exp $
Purpose: smarty template - show tests to add results
Rev:
    20071231 - franciscom - new show/hide section to show exec notes
    20071103 - franciscom - BUGID 700
    20071101 - franciscom - added test automation code
    20070826 - franciscom - added some niftycube effects
    20070519 - franciscom - 
    BUGID 856: Guest user can execute test case
    
    20070211 - franciscom - addede delete logic
    20070205 - franciscom - display test plan custom fields.
    20070125 - franciscom - management of closed build
    20070104 - franciscom - custom field management for test cases
    20070101 - franciscom - custom field management for test suite div
*}	


{assign var="title_sep"  value=$smarty.const.TITLE_SEP}
{assign var="title_sep_type3"  value=$smarty.const.TITLE_SEP_TYPE3}

{assign var="input_enabled_disabled" value="disabled"}
{assign var="att_download_only" value=true}
{assign var="enable_custom_fields" value=false}
{assign var="draw_submit_button" value=false}

{assign var="show_current_build" value=0}
{assign var="my_build_name" value=$build_name|escape}

{lang_get s='build' var='build_title'} 

{lang_get var='labels'
          s='build_is_closed,test_cases_cannot_be_executed,test_exec_notes,test_exec_result,
             th_testsuite,details,warning_delete_execution,title_test_case,th_test_case_id,
             version,has_no_assignment,assigned_to,execution_history,exec_notes,
             last_execution,exec_any_build,date_time_run,test_exec_by,build,exec_status,
             test_status_not_run,tc_not_tested_yet,last_execution,exec_current_build,
	           attachment_mgmt,bug_mgmt,delete,closed_build,alt_notes,alt_attachment_mgmt,
	           img_title_bug_mgmt,img_title_delete_execution,test_exec_summary,title_t_r_on_build,
	           execution_type_manual,execution_type_auto,run_mode,
	           test_exec_steps,test_exec_expected_r,btn_save_tc_exec_results,only_test_cases_assigned_to'}



{assign var="cfg_section" value=$smarty.template|basename|replace:".tpl":"" }
{config_load file="input_dimensions.conf" section=$cfg_section}

{include file="inc_head.tpl" popup='yes' openHead='yes'}
<script language="JavaScript" src="gui/javascript/radio_utils.js" type="text/javascript"></script>
<script language="JavaScript" src="gui/javascript/expandAndCollapseFunctions.js" type="text/javascript"></script>

{if #ROUND_EXEC_HISTORY# || #ROUND_TC_TITLE# || #ROUND_TC_SPEC#}
  {assign var="round_enabled" value=1}
  <script language="JavaScript" src="{$basehref}gui/niftycube/niftycube.js" type="text/javascript"></script>
{/if}

<script language="JavaScript" type="text/javascript">
var msg="{lang_get s='warning_delete_execution'}";
var import_xml_results="{lang_get s='import_xml_results'}";
</script>

{if $smarty.const.USE_EXT_JS_LIBRARY}
  {include file="inc_ext_js.tpl"}
{/if}

<script language="JavaScript" type="text/javascript">
{literal}
function load_notes(panel,exec_id)
{
  var url2load=fRoot+'lib/execute/getExecNotes.php?exec_id=' + exec_id;
  panel.load({url:url2load}); 
}
{/literal}
</script>


</head>
{* 
IMPORTANT: if you change value, you need to chang init_args() logic on execSetResults.php
*}
{assign var="tplan_notes_view_memory_id" value="tpn_view_status"}
{assign var="build_notes_view_memory_id" value="bn_view_status"}
{assign var="bulk_controls_view_memory_id" value="bc_view_status"}


<body onLoad="show_hide('tplan_notes','{$tplan_notes_view_memory_id}',{$tpn_view_status});
              show_hide('build_notes','{$build_notes_view_memory_id}',{$bn_view_status});
              show_hide('bulk_controls','{$bulk_controls_view_memory_id}',{$bc_view_status});
              multiple_show_hide('{$tsd_div_id_list}','{$tsd_hidden_id_list}',
                                 '{$tsd_val_for_hidden_list}');
              {if $round_enabled}Nifty('div.exec_additional_info');{/if}  
              {if #ROUND_TC_SPEC# }Nifty('div.exec_test_spec');{/if}                                 
              {if #ROUND_EXEC_HISTORY# }Nifty('div.exec_history');{/if}
              {if #ROUND_TC_TITLE# }Nifty('div.exec_tc_title');{/if}"> 

<h1>	
 {lang_get s='help' var='text_hint'}
 {include file="inc_help.tpl" help="execMain" locale=$locale 
          alt="$text_hint" title="$text_hint"  style="float: right;"}
 
	{$labels.title_t_r_on_build} {$my_build_name} 
	
	{if $ownerDisplayName != ""}
	  {$title_sep_type3}{$labels.only_test_cases_assigned_to}{$title_sep}{$ownerDisplayName|escape}  
	{/if}
</h1>


{* show echo about update if applicable *}
{$updated}


<div id="main_content" class="workBack">
  {if $build_is_open == 0}
  <div class="warning_message" style="align:center;">
     {$labels.build_is_closed}<br />
     {$labels.test_cases_cannot_be_executed}
  </div>
  <br />
  {/if}

<form method="post" id="execSetResults" name="execSetResults" >

  <input type="hidden" id="do_delete"  name="do_delete" value="0" />
  <input type="hidden" id="exec_to_delete"  name="exec_to_delete" value="0" />

  {* -------------------------------------------------------------------------------- *}
  {* Test Plan notes show/hide management                                             *}
  {* -------------------------------------------------------------------------------- *}
  {lang_get s='test_plan_notes' var='title'}
  {assign var="div_id" value='tplan_notes'}
  {assign var="memstatus_id" value=$tplan_notes_view_memory_id}
  
  {include file="inc_show_hide_mgmt.tpl" 
           args_container_title=$title
           args_container_id=$div_id
           args_container_view_status_id=$memstatus_id}

  <div id="{$div_id}" class="exec_additional_info">
    {$tplan_notes}
    {if $tplan_cf neq ''} <div class="custom_field_container">{$tplan_cf}</div>{/if}
  </div>
  
  {* -------------------------------------------------------------------------------- *}

  {* -------------------------------------------------------------------------------- *}
  {* Build notes show/hide management                                                 *}
  {* -------------------------------------------------------------------------------- *}
  {lang_get s='builds_notes' var='title'}
  {assign var="div_id" value='build_notes'}
  {assign var="memstatus_id" value=$build_notes_view_memory_id}

  {include file="inc_show_hide_mgmt.tpl" 
           args_container_title=$title
           args_container_id=$div_id
           args_container_view_status_id=$memstatus_id
           args_container_draw=true
           args_container_class='exec_additional_info'
           args_container_html=$build_notes}
  {* -------------------------------------------------------------------------------- *}

  
  
  {if $map_last_exec eq ""}
     <div class="warning_message" style="text-align:center"> {lang_get s='no_data_available'}</div>
  {else}
      {if $has_exec_right == 1 and $build_is_open == 1}
        {assign var="input_enabled_disabled" value=""}
        {assign var="att_download_only" value=false}
        {assign var="enable_custom_fields" value=true}
        {assign var="draw_submit_button" value=true}


        {lang_get s='bulk_tc_status_management' var='title'}
        {assign var="div_id" value='bulk_controls'}
        {assign var="memstatus_id" value=$bulk_controls_view_memory_id}
        
        {include file="inc_show_hide_mgmt.tpl" 
                 args_container_title=$title
                 args_container_id=$div_id
                 args_container_view_status_id=$memstatus_id}

        <div id="{$div_id}" name="{$div_id}">
        	{foreach key=verbose_status item=locale_status from=$gsmarty_tc_status_for_ui}
        	   <input type="button" id="btn_{$verbose_status}" name="btn_{$verbose_status}"
        	          value="{lang_get s='set_all_tc_to'} {lang_get s=$locale_status}"
        	          onclick="javascript:check_all_radios('{$gsmarty_tc_status.$verbose_status}');" />
        	{/foreach}		
          <br />
          <br />
      		  <input type="submit" id="do_bulk_save" name="do_bulk_save" 
      		         value="{lang_get s='btn_save_all_tests_results'}"/>
        </div>
    	{/if}
      
      <hr />
      <div class="groupBtn">
    		  <input type="button" name="print" value="{lang_get s='btn_print'}" 
    		         onclick="javascript:window.print();" />
    		  <input type="submit" id="toggle_history_on_off" 
    		         name="{$history_status_btn_name}" 
    		         value="{lang_get s=$history_status_btn_name}" />
    		  <input type="button" id="pop_up_import_button" name="import_xml_button" 
    		         value="{lang_get s='import_xml_results'}" 
    		         onclick="javascript: openImportResult(import_xml_results);" />
		      
		      {if $test_automation_enabled}
		      <input type="submit" id="execute_cases" name="execute_cases" 
		             value="{lang_get s='execute_and_save_results'}"/>
		      {/if}       
    		  <input type="hidden" id="history_on" 
    		         name="history_on" value="{$history_on}" />
      </div>
    <hr />

	{/if}

 	{foreach item=tc_exec from=$map_last_exec}
  	
    {assign var="tc_id" value=$tc_exec.testcase_id}
	  {assign var="tcversion_id" value=$tc_exec.id}
		<input type='hidden' name='tc_version[{$tcversion_id}]' value='{$tc_id}' />

    {* ------------------------------------------------------------------------------------ *}
    {lang_get s='th_testsuite' var='title'}
    {assign var="div_id" value=tsdetails_$tc_id}
    {assign var="memstatus_id" value=tsdetails_view_status_$tc_id}
    {assign var="ts_name"  value=$tsuite_info[$tc_id].tsuite_name|escape}
    {assign var="title" value="$title$title_sep$ts_name"}

    {include file="inc_show_hide_mgmt.tpl" 
             args_container_title=$title
             args_container_id=$div_id
             args_container_view_status_id=$memstatus_id}

		<div id="{$div_id}" name="{$div_id}" class="exec_additional_info">
      <br />
      <div class="exec_testsuite_details" style="width:95%;">
      <span class="legend_container">{lang_get s='details'}</span><br />
		  {$tsuite_info[$tc_id].details}
		  </div>
		  
		  {* 20070104 - franciscom *}
		  {if $ts_cf_smarty[$tc_id] neq ''}
		    <br />
		    <div class="custom_field_container" style="border-color:black;width:95%;">
         {$ts_cf_smarty[$tc_id]}
        </div>
		  {/if}
		  
  		{if $tSuiteAttachments[$tc_id] neq null}
  		  <br />
		    {include file="inc_attachments.tpl" tableName="nodes_hierarchy" downloadOnly=true 
			        	 attachmentInfos=$tSuiteAttachments[$tc_exec.tsuite_id] 
			        	 inheritStyle=1
			        	 tableClassName="none"
				         tableStyles="background-color:#ffffcc;width:100%" }
	    {/if}
	    <br />
    </div>
  

		<div class="exec_tc_title">
		{$labels.title_test_case} {$labels.th_test_case_id}{$tc_exec.testcase_id} :: {$labels.version}: {$tc_exec.version}<br />
		    {$tc_exec.name|escape}<br />
		    {if $tc_exec.assigned_user eq ''}
		      {$labels.has_no_assignment}
		    {else}  
          {$labels.assigned_to}{$title_sep}{$tc_exec.assigned_user|escape}
        {/if}  
    </div>

 		{if $show_last_exec_any_build}
   		{assign var="abs_last_exec" value=$map_last_exec_any_build.$tcversion_id}
 		  {assign var="my_build_name" value=$abs_last_exec.build_name|escape}
 		  {assign var="show_current_build" value=1}
    {/if}
    {assign var="exec_build_title" value="$build_title $title_sep $my_build_name"}


		<div id="execution_history" class="exec_history">
  		<div class="exec_history_title">
  		{if $history_on}
  		    {$labels.execution_history} {$title_sep_type3}
  		    {if !$show_history_all_builds} 
  		      {$exec_build_title}
  		    {/if}  
  		{else}
  			  {$labels.last_execution} 
  			  {if $show_current_build} {$labels.exec_any_build} {/if}
  			  {$title_sep_type3} {$exec_build_title}
  		{/if}
  		</div>

		{* The very last execution for any build of this test plan *}
		{if $show_last_exec_any_build && $history_on==0}
        {if $abs_last_exec.status != '' and $abs_last_exec.status != $gsmarty_tc_status.not_run}			
			    {assign var="status_code" value=$abs_last_exec.status}
    
     			<div class="{$gsmarty_tc_status_css.$status_code}">
     			{$labels.date_time_run} {$title_sep} {localize_timestamp ts=$abs_last_exec.execution_ts}
     			{$title_sep_type3}
     			{$labels.test_exec_by} {$title_sep} {$alluserInfo[$abs_last_exec.tester_id]->getDisplayName()|escape} 
     			{$title_sep_type3}
     			{$labels.build}{$title_sep} {$abs_last_exec.build_name|escape} 			
     			{$title_sep_type3}
     			{$labels.exec_status} {$title_sep} {localize_tc_status s=$status_code}
     			</div>
  		    
  		  {else}
    		   <div class="not_run">{$labels.test_status_not_run}</div>
    			   {$labels.tc_not_tested_yet}
   		  {/if}
    {/if}

    {* -------------------------------------------------------------------------------------------------- *}
    {if $other_exec.$tcversion_id}
      {if $history_on == 0 && $show_current_build}
   		   <div class="exec_history_title">
  			    {$labels.last_execution} {$labels.exec_current_build} 
  			    {$title_sep_type3} {$exec_build_title}
  			 </div>   
		  {/if}

		  <table cellspacing="0" class="exec_history">
			 <tr>
				<th style="text-align:left">{$labels.date_time_run}</th>
        {* 20071103 - BUGID 700 *}
				{if $history_on == 0 || $show_history_all_builds}
				  <th style="text-align:left">{$labels.build}</th>
				{/if}  
				<th style="text-align:left">{$labels.test_exec_by}</th>
				<th style="text-align:center">{$labels.exec_status}</th>
			
				{if $att_model->show_upload_column && !$att_download_only}
						<th style="text-align:center">{$labels.attachment_mgmt}</th>
            {assign var="my_colspan" value=$att_model->num_cols}
        {/if}

				{if $g_bugInterfaceOn}
          <th style="text-align:left">{$labels.bug_mgmt}</th>
          {assign var="my_colspan" value=$my_colspan+1}
        {/if}
        
				{if $can_delete_execution}
          <th style="text-align:left">{$labels.delete}</th>
          {assign var="my_colspan" value=$my_colspan+1}
        {/if}

        {* 20080103 - franciscom *}
        <th style="text-align:left">{$labels.run_mode}</th>
        {assign var="my_colspan" value=$my_colspan+1}


			 </tr>
			 
			{* ----------------------------------------------------------------------------------- *} 
			{foreach item=tc_old_exec from=$other_exec.$tcversion_id}
  	     {assign var="tc_status_code" value=$tc_old_exec.status}

   			<tr style="border-top:1px solid black; background-color:{cycle values='#eeeeee,#d0d0d0'}">
  				<td>{localize_timestamp ts=$tc_old_exec.execution_ts}</td>
  				
				  {if $history_on == 0 || $show_history_all_builds}
  				<td>{if !$tc_old_exec.build_is_open}
  				    <img src="{$smarty.const.TL_THEME_IMG_DIR}/lock.png" title="{$labels.closed_build}">{/if}
  				    {$tc_old_exec.build_name|escape}
  				</td>
  				{/if}
  				
  				<td>{$alluserInfo[$tc_old_exec.tester_id]->getDisplayName()|escape}</td> 
  				<td class="{$gsmarty_tc_status_css.$tc_status_code}" style="text-align:center">
  				    {localize_tc_status s=$tc_old_exec.status}
  				</td>
            
          {if $att_model->show_upload_column && !$att_download_only && $tc_old_exec.build_is_open}
      			  <td align="center"><a href="javascript:openFileUploadWindow({$tc_old_exec.execution_id},'executions')">
      			    <img src="{$smarty.const.TL_THEME_IMG_DIR}/upload_16.png" title="{$labels.alt_attachment_mgmt}"
      			         alt="{$labels.alt_attachment_mgmt}" 
      			         style="border:none" /></a>
              </td>
  	      {/if}
  
    			{if $g_bugInterfaceOn}
       		  	<td align="center"><a href="javascript:open_bug_add_window({$tc_old_exec.execution_id})">
      			    <img src="{$smarty.const.TL_THEME_IMG_DIR}/bug1.gif" title="{$labels.img_title_bug_mgmt}" 
      			         style="border:none" /></a>
              </td>
          {/if}


    			{if $can_delete_execution}
       		  	<td align="center">
             	<a href="javascript:confirm_and_submit(msg,'execSetResults','exec_to_delete',
             	                                       {$tc_old_exec.execution_id},'do_delete',1);">
      			    <img src="{$smarty.const.TL_THEME_IMG_DIR}/trash.png" title="{$labels.img_title_delete_execution}" 
      			         style="border:none" /></a>
              </td>
          {/if}

       		<td class="icon_cell" align="center">
       		  {if $tc_old_exec.execution_type == $smarty.const.TESTCASE_EXECUTION_TYPE_MANUAL}
      		    <img src="{$smarty.const.TL_THEME_IMG_DIR}/user.png" title="{$labels.execution_type_manual}" 
      		            style="border:none" />
       		  {else}
      		    <img src="{$smarty.const.TL_THEME_IMG_DIR}/bullet_wrench.png" title="{$labels.execution_type_auto}" 
      		            style="border:none" />
       		  {/if}
          </td>


            
  			</tr>  
 			  {if $tc_old_exec.execution_notes neq ""}
  			<script>
        {literal}
        Ext.onReady(function(){
		    var p = new Ext.Panel({
        title: {/literal}'{$labels.exec_notes}'{literal},
        collapsible:true,
        collapsed: true,
        /*style: 'padding:2px 1px 1px 2px;', */
        baseCls: 'x-tl-panel',
        /* contentEl: {/literal}'imo{$tc_old_exec.execution_id}'{literal}, */
        renderTo: {/literal}'exec_notes_container_{$tc_old_exec.execution_id}'{literal},
        width:'100%',
        html:''
        });
    
        p.on({'expand' : function(){load_notes(this,{/literal}{$tc_old_exec.execution_id}{literal});}});
        });
        {/literal}
        
  			</script> 
  			<tr>
  			 <td colspan="{$my_colspan}" id="exec_notes_container_{$tc_old_exec.execution_id}" 
  			     style="padding:5px 5px 5px 5px;">
  			</td>
   			</tr>
 			  {/if $tc_old_exec.execution_notes neq ""}
    
  			{* 20070105 - Custom field values  *}
  			<tr>
  			<td colspan="{$my_colspan}">
  				{assign var="execID" value=$tc_old_exec.execution_id}
  				{assign var="cf_value_info" value=$other_exec_cfexec[$execID]}
          {$cf_value_info}
  			</td>
  			</tr>
  
  			
  			
  			{* Attachments *}
  			<tr>
  			<td colspan="{$my_colspan}">
  				{assign var="execID" value=$tc_old_exec.execution_id}
  
  				{assign var="attach_info" value=$attachments[$execID]}
  				{include file="inc_attachments.tpl" 
  				         attachmentInfos=$attach_info 
  				         id=$execID tableName="executions"
  				         show_upload_btn=$att_model->show_upload_btn
  				         show_title=$att_model->show_title 
  				         downloadOnly=$att_download_only
  				         }
  			</td>
  			</tr>
  
        {* Execution Bugs (if any) *}
        {if $bugs_for_exec[$execID] neq ""}
   		<tr>
   			<td colspan="{$my_colspan}">
   				{include file="inc_show_bug_table.tpl" 
   			         bugs_map=$bugs_for_exec[$execID] 
   			         can_delete=true
   			         exec_id=$execID}
   			</td>
   		</tr>
   		{/if}	
		{/foreach}
			{* ----------------------------------------------------------------------------------- *} 

			</table>
		{/if}
  </div> 

  <br />
  
  {* ----------------------------------------------------------------------------------- *}
  <div>
    {include file="execute/inc_exec_test_spec.tpl" 
             args_tc_exec=$tc_exec
             args_labels=$labels  
             args_enable_custom_field=$enable_custom_field 
             args_execution_time_cf=$execution_time_cf
             args_design_time_cf=$design_time_cf
             args_execution_types=$execution_types
             args_tcAttachments=$tcAttachments }

		
    {if $tc_exec.can_be_executed}
      {include file="execute/inc_exec_controls.tpl"
               args_input_enable_mgmt=$input_enabled_disabled
               args_tcversion_id=$tcversion_id 
               args_webeditor=$exec_notes_editors[$tc_id]
               args_labels=$labels}
	  {/if}
 	  {if $tc_exec.active eq 0}
 	   <h1><center>{$labels.testcase_version_is_inactive_on_exec}</center></h1>
 	  {/if}
	<hr />
	</div>
  {* ----------------------------------------------------------------------------------- *}

	{/foreach}
</form>
</div>
</body>
</html>
