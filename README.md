# Test-Bullet DevContainer Project

This is a test project designed to simulate an issue encountered during the upgrade of the Bullet gem from version **8.0.1** to **8.0.3**. The project uses Ruby 3.3.7 inside a DevContainer and employs **minitest**, **rake**, **sqlite3**, and **bullet** along with **activerecord**.

The primary goal of this project is to test and reproduce the conditions where Bullet might behave unexpectedly after the upgrade, specifically in scenarios involving nested attributes and inverse associations.

[Issue link](https://github.com/flyerhzm/bullet/issues/740)

# 8.0.3 Output

```bash
root@b7558d9b8400:/workspaces/test-bullet/8_0_3# BULLET_DEBUG=true rake test
# Running:

[Bullet][Detector::NPlusOneQuery#add_inversed_object] object: 2820, association: customer
[Bullet][Detector::NPlusOneQuery#add_inversed_object] object: 2820, association: customer
[Bullet][Detector::NPlusOneQuery#add_inversed_object] object: 2840, association: customer
[Bullet][Detector::NPlusOneQuery#add_inversed_object] object: 2840, association: customer
[Bullet][Detector::NPlusOneQuery#add_inversed_object] object: 2860, association: user
[Bullet][Detector::NPlusOneQuery#add_inversed_object] object: 2860, association: user
[Bullet][Detector::NPlusOneQuery#update_inversed_object] object from 2860 to Customer:2
[Bullet][Detector::NPlusOneQuery#add_inversed_object] object: 2820, association: customer
[Bullet][Detector::Association#add_call_object_associations] object: Customer:2, associations: addresses
[Bullet][Detector::NPlusOneQuery#call_association] object: Customer:2, associations: addresses
[Bullet][Detector::NPlusOneQuery#update_inversed_object] object from 2820 to CustomerAddress:3
[Bullet][Detector::NPlusOneQuery#add_inversed_object] object: 2840, association: customer
[Bullet][Detector::Association#add_call_object_associations] object: Customer:2, associations: addresses
[Bullet][Detector::NPlusOneQuery#call_association] object: Customer:2, associations: addresses
[Bullet][Detector::NPlusOneQuery#add_possible_objects] objects: CustomerAddress:3, CustomerAddress:
[Bullet][Detector::CounterCache#add_possible_objects] objects: CustomerAddress:3, CustomerAddress:
[Bullet][Detector::Association#add_call_object_associations] object: CustomerAddress:3, associations: user
[Bullet][Detector::NPlusOneQuery#call_association] object: CustomerAddress:3, associations: user
[Bullet][detect n + 1 query] object: CustomerAddress:3, associations: user
[Bullet][Detector::NPlusOneQuery#update_inversed_object] object from 2840 to CustomerAddress:4
E

Finished in 0.040339s, 24.7900 runs/s, 0.0000 assertions/s.

  1) Error:
BulletTest#test_creating_multiple_main_addresses:
Bullet::Notification::UnoptimizedQueryError: user: root
 
USE eager loading detected
  CustomerAddress => [:user]
  Add to your query: .includes([:user])
Call stack
  /workspaces/test-bullet/8_0_3/test/test_bullet_test.rb:46:in `test_creating_multiple_main_addresses'


    /usr/local/bundle/gems/uniform_notifier-1.16.0/lib/uniform_notifier/raise.rb:19:in `_out_of_channel_notify'
    /usr/local/bundle/gems/uniform_notifier-1.16.0/lib/uniform_notifier/base.rb:25:in `out_of_channel_notify'
    /usr/local/bundle/gems/bullet-8.0.3/lib/bullet/notification/base.rb:50:in `notify_out_of_channel'
    /usr/local/bundle/gems/bullet-8.0.3/lib/bullet.rb:212:in `block in perform_out_of_channel_notifications'
    /usr/local/bundle/gems/bullet-8.0.3/lib/bullet.rb:274:in `block (2 levels) in for_each_active_notifier_with_notification'
    /usr/local/lib/ruby/3.3.0/set.rb:501:in `each_key'
    /usr/local/lib/ruby/3.3.0/set.rb:501:in `each'
    /usr/local/bundle/gems/bullet-8.0.3/lib/bullet.rb:272:in `block in for_each_active_notifier_with_notification'
    /usr/local/bundle/gems/bullet-8.0.3/lib/bullet.rb:271:in `each'
    /usr/local/bundle/gems/bullet-8.0.3/lib/bullet.rb:271:in `for_each_active_notifier_with_notification'
    /usr/local/bundle/gems/bullet-8.0.3/lib/bullet.rb:210:in `perform_out_of_channel_notifications'
    test/test_bullet_test.rb:32:in `teardown'

1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
rake aborted!
Command failed with status (1)
/usr/local/bundle/gems/rake-13.2.1/exe/rake:27:in `<top (required)>'
Tasks: TOP => test
(See full trace by running task with --trace)
```

# 8.0.2 Output

```bash
root@b7558d9b8400:/workspaces/test-bullet/8_0_1# BULLET_DEBUG=true rake test

# Running:

[Bullet][Detector::NPlusOneQuery#add_impossible_object] object: Customer:
[Bullet][Detector::Association#add_call_object_associations] object: Customer:, associations: addresses
[Bullet][Detector::NPlusOneQuery#call_association] object: Customer:, associations: addresses
[Bullet][Detector::NPlusOneQuery#add_impossible_object] object: CustomerAddress:
[Bullet][Detector::Association#add_call_object_associations] object: Customer:, associations: addresses
[Bullet][Detector::NPlusOneQuery#call_association] object: Customer:, associations: addresses
[Bullet][Detector::NPlusOneQuery#add_possible_objects] objects: CustomerAddress:, CustomerAddress:
[Bullet][Detector::CounterCache#add_possible_objects] objects: CustomerAddress:, CustomerAddress:
[Bullet][Detector::Association#add_call_object_associations] object: CustomerAddress:, associations: user
[Bullet][Detector::NPlusOneQuery#call_association] object: CustomerAddress:, associations: user
[Bullet][Detector::NPlusOneQuery#add_impossible_object] object: CustomerAddress:
.

Finished in 0.035460s, 28.2008 runs/s, 0.0000 assertions/s.

1 runs, 0 assertions, 0 failures, 0 errors, 0 skips
```


# AR Output

```bash
D, [2025-04-14T15:28:06.678376 #920] DEBUG -- :   TRANSACTION (0.0ms)  begin transaction
D, [2025-04-14T15:28:06.678591 #920] DEBUG -- :   Customer Create (0.3ms)  INSERT INTO "customers" ("name", "user_id") VALUES (?, ?) RETURNING "id"  [["name", "Test Customer"], ["user_id", 1]]
D, [2025-04-14T15:28:06.679183 #920] DEBUG -- :   CustomerAddress Create (0.1ms)  INSERT INTO "customer_addresses" ("city", "main", "customer_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?) RETURNING "id"  [["city", "City 1"], ["main", 1], ["customer_id", 2], ["created_at", "2025-04-14 15:28:06.678908"], ["updated_at", "2025-04-14 15:28:06.678908"]]
D, [2025-04-14T15:28:06.680683 #920] DEBUG -- :   CustomerAddress Create (0.1ms)  INSERT INTO "customer_addresses" ("city", "main", "customer_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?) RETURNING "id"  [["city", "City 2"], ["main", 1], ["customer_id", 2], ["created_at", "2025-04-14 15:28:06.680331"], ["updated_at", "2025-04-14 15:28:06.680331"]]
D, [2025-04-14T15:28:06.680831 #920] DEBUG -- :   TRANSACTION (0.0ms)  commit transaction
```
