package io.ebean.dbmigration;

import io.ebean.Database;
import io.ebean.annotation.Platform;
import io.ebean.config.DatabaseConfig;
import io.ebean.config.dbplatform.DatabasePlatform;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.ServiceLoader;

/**
 * Generates DDL migration scripts based on changes to the current model.
 *
 * <p>
 * Typically this is run as a main method in src/test once a developer is happy
 * with the next set of changes to the model.
 *
 * <h3>Example: Run for a single specific platform</h3>
 *
 * <pre>{@code
 *
 *    DbMigration migration = DbMigration.create();
 *
 *    migration.setPlatform(Platform.POSTGRES);
 *
 *    // optionally specify the version and name
 *    migration.setName("add indexes to customer");
 *
 *    migration.generateMigration();
 *
 * }</pre>
 *
 * <p>
 * Drop column migrations are effectively breaking changes and should
 * be held back and run in a later migration after the columns deleted
 * are no longer being used by the application. These changes are called
 * "pending drops" and we must explicitly specify to include these in
 * a generated migration.
 * <p>
 * Use <code>setGeneratePendingDrop()</code> to specify a prior migration
 * that has drop column changes that we want to generate a migration for.
 *
 * <h3>Example: Generate for pending drops</h3>
 *
 * <pre>{@code
 *
 *    DbMigration migration = DbMigration.create();
 *
 *    migration.setPlatform(Platform.POSTGRES);
 *
 *    // set the migration version that has pending drops
 *    migration.setGeneratePendingDrop("1.3");
 *
 *    // generates the migration with drop column changes
 *    migration.generateMigration();
 *
 * }</pre>
 */
public interface DbMigration {

  /**
   * Create a DbMigration implementation to use.
   */
  static DbMigration create() {
    Iterator<DbMigration> loader = ServiceLoader.load(DbMigration.class).iterator();
    if (loader.hasNext()) {
      return loader.next();
    }
    throw new IllegalStateException("No service implementation found for DbMigration?");
  }

  /**
   * Set logging to System out (defaults to true).
   */
  void setLogToSystemOut(boolean logToSystemOut);

  /**
   * Set the path from the current working directory to the application resources.
   * <p>
   * This defaults to maven style 'src/main/resources'.
   */
  void setPathToResources(String pathToResources);

  /**
   * Set the path where migrations are generated to (which defaults to "dbmigration").
   * <p>
   * Normally we only use this when we use Ebean to generate the database migrations
   * and then use some other tool like FlywayDB to run the migrations.
   * <p>
   * Example: with <code>setMigrationPath("db/migration")</code> ... the migrations
   * are generated into <code>src/resources/db/migration</code>.
   * <p>
   * Note that if Ebean migration runner is used we should not use this method but
   * instead set the migrationPath via a property such that both the migration generator
   * and migration runner both use the same path.
   *
   * @param migrationPath The path that migrations are generated into.
   */
  void setMigrationPath(String migrationPath);

  /**
   * Set the server to use to determine the current model. Usually this is not called explicitly.
   */
  void setServer(Database database);

  /**
   * Set the DatabaseConfig to use. Usually this is not called explicitly.
   */
  void setServerConfig(DatabaseConfig config);

  /**
   * Set the specific platform to generate DDL for.
   * <p>
   * If not set this defaults to the platform of the default database.
   */
  void setPlatform(Platform platform);

  /**
   * Set the specific platform to generate DDL for.
   * <p>
   * If not set this defaults to the platform of the default database.
   */
  void setPlatform(DatabasePlatform databasePlatform);

  /**
   * Set to false in order to turn off strict mode.
   * <p>
   * Strict mode checks that a column changed to non-null on an existing table via DB migration has a default
   * value specified. Set this to false if that isn't the case but it is known that all the existing rows have
   * a value specified (there are no existing null values for the column).
   */
  void setStrictMode(boolean strictMode);

  /**
   * Set to include generation of the index migration file.
   * <p>
   * When true this generates a {@code idx_<platform>.migrations} file. This can be used by the migration
   * runner to improve performance of running migrations, especially when no migration changes have occurred.
   */
  void setIncludeIndex(boolean generateIndexFile);

  /**
   * Set to true to include a generated header comment in the DDL script.
   */
  void setIncludeGeneratedFileComment(boolean includeGeneratedFileComment);

  /**
   * Set this to false to exclude the builtin support for table partitioning (with @DbPartition).
   */
  void setIncludeBuiltInPartitioning(boolean includeBuiltInPartitioning);

  /**
   * Set the header that is included in the generated DDL script.
   */
  void setHeader(String header);

  /**
   * Set the prefix for the version. Set this to "V" for use with Flyway.
   */
  void setApplyPrefix(String applyPrefix);

  /**
   * Set the version of the migration to be generated.
   */
  void setVersion(String version);

  /**
   * Set the name of the migration to be generated.
   */
  void setName(String name);

  /**
   * Generate a migration for the version specified that contains pending drops.
   *
   * @param generatePendingDrop The version of a prior migration that holds pending drops.
   */
  void setGeneratePendingDrop(String generatePendingDrop);

  /**
   * Set to true if ALTER TABLE ADD FOREIGN KEY should be generated with an option to skip validation.
   * <p>
   * Currently this is only useful for Postgres DDL adding the <code>NOT VALID</code> option.
   */
  void setAddForeignKeySkipCheck(boolean addForeignKeySkipCheck);

  /**
   * Set the lock timeout to be included with the DDL generation.
   * <p>
   * Currently this is only useful for Postgres migrations adding a <code>set lock_timeout</code>
   * statement to the generated database migration.
   */
  void setLockTimeout(int seconds);

  /**
   * Add a platform to write the migration DDL.
   * <p>
   * Use this when you want to generate sql scripts for multiple database platforms
   * from the migration (e.g. generate migration sql for MySql, Postgres and Oracle).
   */
  void addPlatform(Platform platform);

  /**
   * Add a platform to write with a given prefix.
   */
  void addPlatform(Platform platform, String prefix);

  /**
   * Add a databasePlatform to write the migration DDL.
   * <p>
   * Use this when you want to add preconfigured database platforms.
   */
  void addDatabasePlatform(DatabasePlatform databasePlatform, String prefix);

  /**
   * Return the list of versions that contain pending drops.
   */
  List<String> getPendingDrops();

  /**
   * Generate the next migration sql script and associated model xml.
   * <p>
   * This does not run the migration or ddl scripts but just generates them.
   * </p>
   * <h3>Example: Run for a single specific platform</h3>
   * <pre>{@code
   *
   *   DbMigration migration = DbMigration.create();
   *   migration.setPlatform(Platform.POSTGRES);
   *
   *   migration.generateMigration();
   *
   * }</pre>
   * <p>
   *
   * <h3>Example: Generate for "pending drops" (drop column changes)</h3>
   *
   * <pre>{@code
   *
   *    DbMigration migration = DbMigration.create();
   *
   *    migration.setPlatform(Platform.POSTGRES);
   *
   *    // set the migration version that has pending drops
   *    migration.setGeneratePendingDrop("1.3");
   *
   *    // generates the migration with drop column changes
   *    migration.generateMigration();
   *
   * }</pre>
   *
   * <h3>Example: Run migration generating DDL for multiple platforms</h3>
   * <pre>{@code
   *
   *   DbMigration migration = DbMigration.create();
   *
   *   migration.setPathToResources("src/main/resources");
   *
   *   migration.addPlatform(Platform.POSTGRES);
   *   migration.addPlatform(Platform.MYSQL);
   *   migration.addPlatform(Platform.ORACLE);
   *
   *   migration.generateMigration();
   *
   * }</pre>
   *
   * @return the version of the generated migration or null
   */
  String generateMigration() throws IOException;

  /**
   * Generate an "init" migration which has all changes.
   * <p>
   * An "init" migration can only be executed and used on a database that has had no
   * prior migrations run on it.
   * </p>
   *
   * @return the version of the generated migration
   */
  String generateInitMigration() throws IOException;

}
