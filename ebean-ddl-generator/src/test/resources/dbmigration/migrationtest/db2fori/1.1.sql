-- Migrationscripts for ebean unittest
-- apply changes
create table migtest_e_user (
  id                            integer auto_increment not null,
  constraint pk_migtest_e_user primary key (id)
);

create table migtest_mtm_c_migtest_mtm_m (
  migtest_mtm_c_id              integer not null,
  migtest_mtm_m_id              bigint not null,
  constraint pk_migtest_mtm_c_migtest_mtm_m primary key (migtest_mtm_c_id,migtest_mtm_m_id)
);

create table migtest_mtm_m_migtest_mtm_c (
  migtest_mtm_m_id              bigint not null,
  migtest_mtm_c_id              integer not null,
  constraint pk_migtest_mtm_m_migtest_mtm_c primary key (migtest_mtm_m_id,migtest_mtm_c_id)
);

alter table migtest_ckey_detail add column one_key integer;
alter table migtest_ckey_detail add column two_key varchar(127);

alter table migtest_ckey_detail add constraint fk_mgtst_ck_e1qkb5 foreign key (one_key,two_key) references migtest_ckey_parent (one_key,two_key) on delete restrict on update restrict;
alter table migtest_ckey_parent add column assoc_id integer;

alter table migtest_fk_cascade drop constraint if exists fk_mgtst_fk_65kf6l;
alter table migtest_fk_cascade add constraint fk_mgtst_fk_65kf6l foreign key (one_id) references migtest_fk_cascade_one (id) on delete restrict on update restrict;
alter table migtest_fk_none add constraint fk_mgtst_fk_nn_n_d foreign key (one_id) references migtest_fk_one (id) on delete restrict on update restrict;
alter table migtest_fk_none_via_join add constraint fk_mgtst_fk_9tknzj foreign key (one_id) references migtest_fk_one (id) on delete restrict on update restrict;
alter table migtest_fk_set_null drop constraint if exists fk_mgtst_fk_wicx8x;
alter table migtest_fk_set_null add constraint fk_mgtst_fk_wicx8x foreign key (one_id) references migtest_fk_one (id) on delete restrict on update restrict;

update migtest_e_basic set status = 'A' where status is null;
alter table migtest_e_basic drop constraint if exists ck_mgtst__bsc_stts;
alter table migtest_e_basic alter column status set default 'A';
alter table migtest_e_basic alter column status set not null;
alter table migtest_e_basic add constraint ck_mgtst__bsc_stts check ( status in ('N','A','I','?'));
alter table migtest_e_basic drop constraint if exists ck_mgtst__b_z543fg;
alter table migtest_e_basic alter column status2 varchar(127);
alter table migtest_e_basic alter column status2 drop default;
alter table migtest_e_basic alter column status2 set null;

-- rename all collisions;
alter table migtest_e_basic add constraint uq_mgtst__b_vs45xo unique  (description);

insert into migtest_e_user (id) select distinct user_id from migtest_e_basic;
alter table migtest_e_basic add constraint fk_mgtst__bsc_sr_d foreign key (user_id) references migtest_e_user (id) on delete restrict on update restrict;
alter table migtest_e_basic alter column user_id set null;
alter table migtest_e_basic add column new_string_field varchar(255) default 'foo''bar' not null;
alter table migtest_e_basic add column new_boolean_field smallint default 0 default true not null;
update migtest_e_basic set new_boolean_field = old_boolean;

alter table migtest_e_basic add column new_boolean_field2 smallint default 0 default true not null;
alter table migtest_e_basic add column progress integer default 0 not null;
alter table migtest_e_basic add constraint ck_mgtst__b_l39g41 check ( progress in (0,1,2));
alter table migtest_e_basic add column new_integer integer default 42 not null;

alter table migtest_e_basic drop constraint uq_mgtst__b_4aybzy;
alter table migtest_e_basic drop constraint uq_mgtst__b_4ayc02;
alter table migtest_e_basic add constraint uq_mgtst__b_ucfcne unique  (status,indextest1);
alter table migtest_e_basic add constraint uq_mgtst__bsc_nm unique  (name);
alter table migtest_e_basic add constraint uq_mgtst__b_4ayc00 unique  (indextest4);
alter table migtest_e_basic add constraint uq_mgtst__b_4ayc01 unique  (indextest5);
alter table migtest_e_enum drop constraint if exists ck_mgtst__n_773sok;
comment on column migtest_e_history.test_string is 'Column altered to long now';
alter table migtest_e_history alter column test_string bigint;
comment on table migtest_e_history is 'We have history now';

-- NOTE: table has @History - special migration may be necessary
update migtest_e_history2 set test_string = 'unknown' where test_string is null;
alter table migtest_e_history2 alter column test_string set default 'unknown';
alter table migtest_e_history2 alter column test_string set not null;
alter table migtest_e_history2 add column test_string2 varchar(255);
alter table migtest_e_history2 add column test_string3 varchar(255) default 'unknown' not null;
alter table migtest_e_history2 add column new_column varchar(20);

alter table migtest_e_history4 alter column test_number bigint;
alter table migtest_e_history5 add column test_boolean smallint default 0 default false not null;


-- NOTE: table has @History - special migration may be necessary
update migtest_e_history6 set test_number1 = 42 where test_number1 is null;
alter table migtest_e_history6 alter column test_number1 set default 42;
alter table migtest_e_history6 alter column test_number1 set not null;
alter table migtest_e_history6 alter column test_number2 set null;
alter table migtest_e_softdelete add column deleted smallint default 0 default false not null;

alter table migtest_oto_child add column master_id bigint;

create index ix_mgtst__b_eu8css on migtest_e_basic (indextest3);
create index ix_mgtst__b_eu8csv on migtest_e_basic (indextest6);
drop index if exists ix_mgtst__b_eu8csq;
drop index if exists ix_mgtst__b_eu8csu;
create index ix_mgtst_mt_3ug4ok on migtest_mtm_c_migtest_mtm_m (migtest_mtm_c_id);
alter table migtest_mtm_c_migtest_mtm_m add constraint fk_mgtst_mt_93awga foreign key (migtest_mtm_c_id) references migtest_mtm_c (id) on delete restrict on update restrict;

create index ix_mgtst_mt_3ug4ou on migtest_mtm_c_migtest_mtm_m (migtest_mtm_m_id);
alter table migtest_mtm_c_migtest_mtm_m add constraint fk_mgtst_mt_93awgk foreign key (migtest_mtm_m_id) references migtest_mtm_m (id) on delete restrict on update restrict;

create index ix_mgtst_mt_b7nbcu on migtest_mtm_m_migtest_mtm_c (migtest_mtm_m_id);
alter table migtest_mtm_m_migtest_mtm_c add constraint fk_mgtst_mt_ggi34k foreign key (migtest_mtm_m_id) references migtest_mtm_m (id) on delete restrict on update restrict;

create index ix_mgtst_mt_b7nbck on migtest_mtm_m_migtest_mtm_c (migtest_mtm_c_id);
alter table migtest_mtm_m_migtest_mtm_c add constraint fk_mgtst_mt_ggi34a foreign key (migtest_mtm_c_id) references migtest_mtm_c (id) on delete restrict on update restrict;

create index ix_mgtst_ck_x45o21 on migtest_ckey_parent (assoc_id);
alter table migtest_ckey_parent add constraint fk_mgtst_ck_da00mr foreign key (assoc_id) references migtest_ckey_assoc (id) on delete restrict on update restrict;

alter table migtest_oto_child add constraint fk_mgtst_t__csyl38 foreign key (master_id) references migtest_oto_master (id) on delete restrict on update restrict;

