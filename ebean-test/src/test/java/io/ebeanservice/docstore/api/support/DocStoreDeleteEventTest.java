package io.ebeanservice.docstore.api.support;

import io.ebean.DB;
import io.ebean.Database;
import io.ebean.DocStoreQueueEntry;
import io.ebean.plugin.BeanDocType;
import io.ebean.plugin.BeanType;
import io.ebeanservice.docstore.api.DocStoreUpdates;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.tests.model.basic.Order;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

public class DocStoreDeleteEventTest {

  static Database server = DB.getDefault();

  <T> BeanType<T> beanType(Class<T> cls) {
    return server.pluginApi().beanType(cls);
  }

  BeanType<Order> orderType() {
    return beanType(Order.class);
  }

  @Test
  @SuppressWarnings("unchecked")
  public void docStoreUpdate() throws Exception {

    BeanType<Order> mock = (BeanType<Order>) Mockito.mock(BeanType.class);
    BeanDocType<Order> mockDocType = (BeanDocType<Order>) Mockito.mock(BeanDocType.class);
    when(mock.docStore()).thenReturn(mockDocType);

    DocStoreDeleteEvent event = new DocStoreDeleteEvent(mock, 42);
    event.docStoreUpdate(null);

    verify(mock, times(1)).docStore();
    verify(mockDocType, times(1)).deleteById(42, null);
  }

  @Test
  public void addToQueue() {

    DocStoreDeleteEvent event = new DocStoreDeleteEvent(orderType(), 42);

    DocStoreUpdates updates = new DocStoreUpdates();
    event.addToQueue(updates);

    List<DocStoreQueueEntry> queueEntries = updates.getQueueEntries();
    assertThat(queueEntries).hasSize(1);

    DocStoreQueueEntry entry = queueEntries.get(0);
    assertThat(entry.getBeanId()).isEqualTo(42);
    assertThat(entry.getQueueId()).isEqualTo("order");
    assertThat(entry.getPath()).isNull();
    assertThat(entry.getType()).isEqualTo(DocStoreQueueEntry.Action.DELETE);
  }
}
