--	Daily rollup logic for compiling Mautic marketing stats into a central table for data studio

DROP TABLE IF EXISTS `email_stats_daily_rollup`;
CREATE TABLE `email_stats_daily_rollup`  AS 
SELECT
	l.email AS email1,
	e.`name` AS e_name1,
	l.firstname AS firstname1,
	l.lastname AS lastname1,
	DATE( es.date_sent ) AS date_sent1,
	DATE( es.date_read ) AS date_read1,
IF
	( cut.hits IS NULL, 0, 1 ) AS is_hit1,
	IFNULL( cut.hits, 0 ) AS hits1,
	IFNULL( cut.unique_hits, 0 ) AS unique_hits1,
IF
	( dnc.id IS NOT NULL AND dnc.reason = 1, 1, 0 ) AS unsubscribed1,
	c.title AS category_title1,
	e.`subject` AS subject2,
	e.sent_count AS sent_count1,
	es.is_read AS is_read1,
	es.viewed_in_browser AS viewed_in_browser1,
--	vp.id AS id1,
--	vp.`subject` AS subject1,
	DATE( e.variant_start_date ) AS variant_start_date1,
IF
	( dnc.id IS NOT NULL AND dnc.reason = 2, 1, 0 ) AS bounced1,
	cmp.`name` AS name1,
	clel.campaign_id AS campaign_id1,
	c.id AS category_id1,
	comp.companyaddress1 AS companyaddress11,
	comp.companyaddress2 AS companyaddress21,
	comp.companyannual_revenue AS companyannual_revenue1,
	comp.companycity AS companycity1,
	comp.companyemail AS companyemail1,
	comp.companyname AS companyname1,
	comp.companycountry AS companycountry1,
	comp.companydescription AS companydescription1,
	comp.companyfax AS companyfax1,
	comp.id AS comp_id1,
	comp.companyindustry AS companyindustry1,
	comp.companynumber_of_employees AS companynumber_of_employees1,
	comp.companyphone AS companyphone1,
	comp.companystate AS companystate1,
	comp.companywebsite AS companywebsite1,
	comp.companyzipcode AS companyzipcode1,
	l.address1 AS address11,
	l.address2 AS address21,
	l.attribution AS attribution1,
	l.attribution_date AS attribution_date1,
	l.city AS city1,
	l.company AS company1,
	l.country AS country1,
	l.facebook AS facebook1,
	l.fax AS fax1,
	l.foursquare AS foursquare1,
	l.googleplus AS googleplus1,
	l.id AS contactId1,
	l.instagram AS instagram1,
	l.linkedin AS linkedin1,
	l.mobile AS mobile1,
	l.phone AS phone1,
	l.points AS points1,
	l.position AS position1,
	l.preferred_locale AS preferred_locale1,
	l.skype AS skype1,
	l.state AS state1,
	l.title AS title1,
	l.twitter AS twitter1,
	l.website AS website1,
	l.zipcode AS zipcode1,
	e.created_by_user AS e_created_by_user1,
	e.date_added AS e_date_added1,
	e.date_modified AS e_date_modified1,
	e.description AS e_description1,
	es.email_address AS email_address1,
	e.id AS e_id1,
--	i.ip_address AS ip_address1,
	es.is_failed AS is_failed1,
	e.is_published AS e_is_published1,
	companies_lead.is_primary AS is_primary1,
	e.lang AS lang1,
	e.modified_by_user AS e_modified_by_user1,
	es.source AS source1,
	es.source_id AS source_id1,
	e.publish_down AS e_publish_down1,
	e.publish_up AS e_publish_up1,
IF
	( es.date_read IS NOT NULL, TIMEDIFF( es.date_read, es.date_sent ), '-' ) AS read_delay1,
	es.retry_count AS retry_count1,
	e.revision AS revision1 
FROM
	mauticdb_email_stats es
	LEFT JOIN mauticdb_emails e ON e.id = es.email_id
	LEFT JOIN mauticdb_leads l ON l.id = es.lead_id
--	LEFT JOIN mauticdb_ip_addresses i ON i.id = es.ip_id
--	LEFT JOIN mauticdb_emails vp ON vp.id = e.variant_parent_id
	LEFT JOIN mauticdb_categories c ON c.id = e.category_id
	LEFT JOIN (
	SELECT
		COUNT( ph.id ) AS hits,
		COUNT(
		DISTINCT ( ph.redirect_id )) AS unique_hits,
		cut2.channel_id,
		ph.lead_id 
	FROM
		mauticdb_channel_url_trackables cut2
		INNER JOIN mauticdb_page_hits ph ON cut2.redirect_id = ph.redirect_id 
		AND cut2.channel_id = ph.source_id 
	WHERE
		cut2.channel = 'email' 
		AND ph.source = 'email' 
	GROUP BY
		cut2.channel_id,
		ph.lead_id 
	) cut ON e.id = cut.channel_id 
	AND es.lead_id = cut.lead_id
	LEFT JOIN mauticdb_lead_donotcontact dnc ON e.id = dnc.channel_id 
	AND dnc.channel = 'email' 
	AND es.lead_id = dnc.lead_id
	LEFT JOIN mauticdb_campaign_lead_event_log clel ON clel.channel = "email" 
	AND e.id = clel.channel_id 
	AND clel.lead_id = l.id
	LEFT JOIN mauticdb_campaigns cmp ON cmp.id = clel.campaign_id
	LEFT JOIN mauticdb_companies_leads companies_lead ON l.id = companies_lead.lead_id
	LEFT JOIN mauticdb_companies comp ON companies_lead.company_id = comp.id 
WHERE
	es.date_sent IS NOT NULL 
	limit 10
	
	;
	
	
	
	-- Phase 2 of query

TRUNCATE TABLE `email_stats_daily_rollup`;
INSERT IGNORE `email_stats_daily_rollup`


SELECT
	l.email AS email1,
	e.`name` AS e_name1,
	l.firstname AS firstname1,
	l.lastname AS lastname1,
	DATE( es.date_sent ) AS date_sent1,
	DATE( es.date_read ) AS date_read1,
IF
	( cut.hits IS NULL, 0, 1 ) AS is_hit1,
	IFNULL( cut.hits, 0 ) AS hits1,
	IFNULL( cut.unique_hits, 0 ) AS unique_hits1,
IF
	( dnc.id IS NOT NULL AND dnc.reason = 1, 1, 0 ) AS unsubscribed1,
	c.title AS category_title1,
	e.`subject` AS subject2,
	e.sent_count AS sent_count1,
	es.is_read AS is_read1,
	es.viewed_in_browser AS viewed_in_browser1,
--	vp.id AS id1,
--	vp.`subject` AS subject1,
	DATE( e.variant_start_date ) AS variant_start_date1,
IF
	( dnc.id IS NOT NULL AND dnc.reason = 2, 1, 0 ) AS bounced1,
	cmp.`name` AS name1,
	clel.campaign_id AS campaign_id1,
	c.id AS category_id1,
	comp.companyaddress1 AS companyaddress11,
	comp.companyaddress2 AS companyaddress21,
	comp.companyannual_revenue AS companyannual_revenue1,
	comp.companycity AS companycity1,
	comp.companyemail AS companyemail1,
	comp.companyname AS companyname1,
	comp.companycountry AS companycountry1,
	comp.companydescription AS companydescription1,
	comp.companyfax AS companyfax1,
	comp.id AS comp_id1,
	comp.companyindustry AS companyindustry1,
	comp.companynumber_of_employees AS companynumber_of_employees1,
	comp.companyphone AS companyphone1,
	comp.companystate AS companystate1,
	comp.companywebsite AS companywebsite1,
	comp.companyzipcode AS companyzipcode1,
	l.address1 AS address11,
	l.address2 AS address21,
	l.attribution AS attribution1,
	l.attribution_date AS attribution_date1,
	l.city AS city1,
	l.company AS company1,
	l.country AS country1,
	l.facebook AS facebook1,
	l.fax AS fax1,
	l.foursquare AS foursquare1,
	l.googleplus AS googleplus1,
	l.id AS contactId1,
	l.instagram AS instagram1,
	l.linkedin AS linkedin1,
	l.mobile AS mobile1,
	l.phone AS phone1,
	l.points AS points1,
	l.position AS position1,
	l.preferred_locale AS preferred_locale1,
	l.skype AS skype1,
	l.state AS state1,
	l.title AS title1,
	l.twitter AS twitter1,
	l.website AS website1,
	l.zipcode AS zipcode1,
	e.created_by_user AS e_created_by_user1,
	e.date_added AS e_date_added1,
	e.date_modified AS e_date_modified1,
	e.description AS e_description1,
	es.email_address AS email_address1,
	e.id AS e_id1,
--	i.ip_address AS ip_address1,
	es.is_failed AS is_failed1,
	e.is_published AS e_is_published1,
	companies_lead.is_primary AS is_primary1,
	e.lang AS lang1,
	e.modified_by_user AS e_modified_by_user1,
	es.source AS source1,
	es.source_id AS source_id1,
	e.publish_down AS e_publish_down1,
	e.publish_up AS e_publish_up1,
IF
	( es.date_read IS NOT NULL, TIMEDIFF( es.date_read, es.date_sent ), '-' ) AS read_delay1,
	es.retry_count AS retry_count1,
	e.revision AS revision1 
FROM
	mauticdb_email_stats es
	LEFT JOIN mauticdb_emails e ON e.id = es.email_id
	LEFT JOIN mauticdb_leads l ON l.id = es.lead_id
--	LEFT JOIN mauticdb_ip_addresses i ON i.id = es.ip_id
--	LEFT JOIN mauticdb_emails vp ON vp.id = e.variant_parent_id
	LEFT JOIN mauticdb_categories c ON c.id = e.category_id
	LEFT JOIN (
	SELECT
		COUNT( ph.id ) AS hits,
		COUNT(
		DISTINCT ( ph.redirect_id )) AS unique_hits,
		cut2.channel_id,
		ph.lead_id 
	FROM
		mauticdb_channel_url_trackables cut2
		INNER JOIN mauticdb_page_hits ph ON cut2.redirect_id = ph.redirect_id 
		AND cut2.channel_id = ph.source_id 
	WHERE
		cut2.channel = 'email' 
		AND ph.source = 'email' 
	GROUP BY
		cut2.channel_id,
		ph.lead_id 
	) cut ON e.id = cut.channel_id 
	AND es.lead_id = cut.lead_id
	LEFT JOIN mauticdb_lead_donotcontact dnc ON e.id = dnc.channel_id 
	AND dnc.channel = 'email' 
	AND es.lead_id = dnc.lead_id
	LEFT JOIN mauticdb_campaign_lead_event_log clel ON clel.channel = "email" 
	AND e.id = clel.channel_id 
	AND clel.lead_id = l.id
	LEFT JOIN mauticdb_campaigns cmp ON cmp.id = clel.campaign_id
	LEFT JOIN mauticdb_companies_leads companies_lead ON l.id = companies_lead.lead_id
	LEFT JOIN mauticdb_companies comp ON companies_lead.company_id = comp.id 
WHERE
	es.date_sent IS NOT NULL 
--	limit 1000
	
	;