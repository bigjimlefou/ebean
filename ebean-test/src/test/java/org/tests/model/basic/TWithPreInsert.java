package org.tests.model.basic;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

import static javax.persistence.CascadeType.ALL;

@Entity
public class TWithPreInsert implements TWithPreInsertCommon {

  @Id
  private Integer id;

  @NotNull
  private String name;

  private String title;

  @OneToMany(cascade = ALL)
  private List<TWithPreInsertChild> children = new ArrayList<>();

  /**
   * For testing what happened in persist controller.
   */
  transient int requestCascadeState;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public List<TWithPreInsertChild> children() {
    return children;
  }

  public int requestCascadeState() {
    return requestCascadeState;
  }

  public void requestCascadeState(int requestCascadeState) {
    this.requestCascadeState = requestCascadeState;
  }
}
