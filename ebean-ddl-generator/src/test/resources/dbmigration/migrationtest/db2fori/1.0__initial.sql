-- Migrationscripts for ebean unittest
-- apply changes
create table migtest_ckey_assoc (
  id                            integer auto_increment not null,
  assoc_one                     varchar(255),
  constraint pk_migtest_ckey_assoc primary key (id)
);

create table migtest_ckey_detail (
  id                            integer auto_increment not null,
  something                     varchar(255),
  constraint pk_migtest_ckey_detail primary key (id)
);

create table migtest_ckey_parent (
  one_key                       integer not null,
  two_key                       varchar(127) not null,
  name                          varchar(255),
  version                       integer not null,
  constraint pk_migtest_ckey_parent primary key (one_key,two_key)
);

create table migtest_fk_cascade (
  id                            bigint auto_increment not null,
  one_id                        bigint,
  constraint pk_migtest_fk_cascade primary key (id)
);

create table migtest_fk_cascade_one (
  id                            bigint auto_increment not null,
  constraint pk_migtest_fk_cascade_one primary key (id)
);

create table migtest_fk_none (
  id                            bigint auto_increment not null,
  one_id                        bigint,
  constraint pk_migtest_fk_none primary key (id)
);

create table migtest_fk_none_via_join (
  id                            bigint auto_increment not null,
  one_id                        bigint,
  constraint pk_migtest_fk_none_via_join primary key (id)
);

create table migtest_fk_one (
  id                            bigint auto_increment not null,
  constraint pk_migtest_fk_one primary key (id)
);

create table migtest_fk_set_null (
  id                            bigint auto_increment not null,
  one_id                        bigint,
  constraint pk_migtest_fk_set_null primary key (id)
);

create table migtest_e_basic (
  id                            integer auto_increment not null,
  status                        varchar(1),
  status2                       varchar(1) default 'N' not null,
  name                          varchar(127),
  description                   varchar(127),
  some_date                     timestamp,
  old_boolean                   smallint default 0 default false not null,
  old_boolean2                  smallint default 0,
  eref_id                       integer,
  indextest1                    varchar(127),
  indextest2                    varchar(127),
  indextest3                    varchar(127),
  indextest4                    varchar(127),
  indextest5                    varchar(127),
  indextest6                    varchar(127),
  user_id                       integer not null,
  constraint ck_mgtst__bsc_stts check ( status in ('N','A','I')),
  constraint ck_mgtst__b_z543fg check ( status2 in ('N','A','I')),
  constraint uq_migtest_e_basic_indextest2 unique (indextest2),
  constraint uq_migtest_e_basic_indextest6 unique (indextest6),
  constraint pk_migtest_e_basic primary key (id)
);

create table migtest_e_enum (
  id                            integer auto_increment not null,
  test_status                   varchar(1),
  constraint ck_mgtst__n_773sok check ( test_status in ('N','A','I')),
  constraint pk_migtest_e_enum primary key (id)
);

create table migtest_e_history (
  id                            integer auto_increment not null,
  test_string                   varchar(255),
  constraint pk_migtest_e_history primary key (id)
);

create table migtest_e_history2 (
  id                            integer auto_increment not null,
  test_string                   varchar(255),
  obsolete_string1              varchar(255),
  obsolete_string2              varchar(255),
  constraint pk_migtest_e_history2 primary key (id)
);

create table migtest_e_history3 (
  id                            integer auto_increment not null,
  test_string                   varchar(255),
  constraint pk_migtest_e_history3 primary key (id)
);

create table migtest_e_history4 (
  id                            integer auto_increment not null,
  test_number                   integer,
  constraint pk_migtest_e_history4 primary key (id)
);

create table migtest_e_history5 (
  id                            integer auto_increment not null,
  test_number                   integer,
  constraint pk_migtest_e_history5 primary key (id)
);

create table migtest_e_history6 (
  id                            integer auto_increment not null,
  test_number1                  integer,
  test_number2                  integer not null,
  constraint pk_migtest_e_history6 primary key (id)
);

create table migtest_e_ref (
  id                            integer auto_increment not null,
  name                          varchar(127) not null,
  constraint uq_migtest_e_ref_name unique (name),
  constraint pk_migtest_e_ref primary key (id)
);

create table migtest_e_softdelete (
  id                            integer auto_increment not null,
  test_string                   varchar(255),
  constraint pk_migtest_e_softdelete primary key (id)
);

create table migtest_mtm_c (
  id                            integer auto_increment not null,
  name                          varchar(255),
  constraint pk_migtest_mtm_c primary key (id)
);

create table migtest_mtm_m (
  id                            bigint auto_increment not null,
  name                          varchar(255),
  constraint pk_migtest_mtm_m primary key (id)
);

create table migtest_oto_child (
  id                            integer auto_increment not null,
  name                          varchar(255),
  constraint pk_migtest_oto_child primary key (id)
);

create table migtest_oto_master (
  id                            bigint auto_increment not null,
  name                          varchar(255),
  constraint pk_migtest_oto_master primary key (id)
);

create index ix_mgtst__b_eu8csq on migtest_e_basic (indextest1);
create index ix_mgtst__b_eu8csu on migtest_e_basic (indextest5);
create index ix_mgtst_fk_mok1xj on migtest_fk_cascade (one_id);
alter table migtest_fk_cascade add constraint fk_mgtst_fk_65kf6l foreign key (one_id) references migtest_fk_cascade_one (id) on delete cascade on update restrict;

create index ix_mgtst_fk_c4p3mv on migtest_fk_set_null (one_id);
alter table migtest_fk_set_null add constraint fk_mgtst_fk_wicx8x foreign key (one_id) references migtest_fk_one (id) on delete set null on update restrict;

create index ix_mgtst__bsc_rf_d on migtest_e_basic (eref_id);
alter table migtest_e_basic add constraint fk_mgtst__bsc_rf_d foreign key (eref_id) references migtest_e_ref (id) on delete restrict on update restrict;

