------------------------------------------------------------------------------
-- Clear and load SymmetricDS Configuration
------------------------------------------------------------------------------

delete from sym_trigger_router;
delete from sym_trigger;
delete from sym_router;
delete from sym_channel where channel_id in ('default');
delete from sym_node_group_link;
delete from sym_node_group;
delete from sym_node_host;
delete from sym_node_identity;
delete from sym_node_security;
delete from sym_node;

------------------------------------------------------------------------------
-- Channels
------------------------------------------------------------------------------

insert into sym_channel
(channel_id, processing_order, max_batch_size, enabled, description)
values('default', 1, 100000, 1, '');

------------------------------------------------------------------------------
-- Node Groups
------------------------------------------------------------------------------

insert into sym_node_group (node_group_id) values ('root');
insert into sym_node_group (node_group_id) values ('child');

------------------------------------------------------------------------------
-- Node Group Links
------------------------------------------------------------------------------

insert into sym_node_group_link (source_node_group_id, target_node_group_id, data_event_action) values ('root', 'child', 'W');
insert into sym_node_group_link (source_node_group_id, target_node_group_id, data_event_action) values ('child', 'root', 'P');

------------------------------------------------------------------------------
-- Triggers
------------------------------------------------------------------------------

insert into sym_trigger
(trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('item_selling_price','item_selling_price','default',current_timestamp,current_timestamp);

insert into sym_trigger
(trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('item','item','default',current_timestamp,current_timestamp);

insert into sym_trigger
(trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('sale_transaction','sale_transaction','default',current_timestamp,current_timestamp);

insert into sym_trigger
(trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('sale_return_line_item','sale_return_line_item','default',current_timestamp,current_timestamp);

-- Triggers with capture disabled, so they are used for initial load only
insert into sym_trigger
(trigger_id,source_table_name,channel_id, sync_on_insert, sync_on_update, sync_on_delete,last_update_time,create_time)
values('sale_transaction_corp','sale_transaction','default',0,0,0,current_timestamp,current_timestamp);

insert into sym_trigger
(trigger_id,source_table_name,channel_id, sync_on_insert, sync_on_update, sync_on_delete,last_update_time,create_time)
values('sale_return_line_item_corp','sale_return_line_item','default',0,0,0,current_timestamp,current_timestamp);

------------------------------------------------------------------------------
-- Routers
------------------------------------------------------------------------------

-- Default router sends all data from corp to store
insert into sym_router
(router_id,source_node_group_id,target_node_group_id,router_type,create_time,last_update_time)
values('root_2_child', 'root', 'child', 'default',current_timestamp, current_timestamp);

-- Default router sends all data from store to corp
insert into sym_router
(router_id,source_node_group_id,target_node_group_id,router_type,create_time,last_update_time)
values('child_2_root', 'child', 'root', 'default',current_timestamp, current_timestamp);

------------------------------------------------------------------------------
-- Trigger Routers
------------------------------------------------------------------------------

-- Send all items to all stores
insert into sym_trigger_router
(trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('item','root_2_child', 100, current_timestamp, current_timestamp);

-- Send item prices to associated stores
insert into sym_trigger_router
(trigger_id,router_id,initial_load_order,initial_load_select,last_update_time,create_time)
values('item_selling_price','root_2_child',100,'store_id=''$(externalId)''',current_timestamp,current_timestamp);

-- Send all sales transactions to corp
insert into sym_trigger_router
(trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('sale_transaction','child_2_root', 200, current_timestamp, current_timestamp);

insert into sym_trigger_router
(trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('sale_return_line_item','child_2_root', 200, current_timestamp, current_timestamp);

-- Send all sales transactions to store during initial load
insert into sym_trigger_router
(trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('sale_transaction_corp','root_2_child', 200, current_timestamp, current_timestamp);

insert into sym_trigger_router
(trigger_id,router_id,initial_load_order,last_update_time,create_time)
values('sale_return_line_item_corp','root_2_child', 200, current_timestamp, current_timestamp);
