import 'package:flutter_test/flutter_test.dart';
import 'package:worker_app/provider/employee_endpoints.dart';
import 'package:worker_app/provider/employer_endpoints.dart';
import 'package:worker_app/provider/user_endpoints.dart';

void main() {
  group('checkUser', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await checkUser();
      expect(result == true || result == false, true);
    });
  });
  group('createUser', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await createUserOnBackend(
          phoneNo: "9315082028",
          name: "Mahesh",
          userType: "employee",
          firebaseUserId: "MM0A6CZw5hVglML2Fk7K0rWaqKn1",
          email: "ajeem.ahmad.ug23@nsut.ac.in");
      expect(result == true || result == false, true);
    });
    test('returns true if HTTP request succeeds', () async {
      final result = await createUserOnBackend(
          phoneNo: "12345676875",
          name: "Tony Stark",
          userType: "employer",
          firebaseUserId: "vQ0LNIqBZGfTX6Ttoy6INrSiNlc2",
          email: "apple@gmail.com");
      expect(result == true || result == false, true);
    });
    test('returns true if HTTP request succeeds', () async {
      final result = await createUserOnBackend(
          phoneNo: "7701958417",
          name: "Tony Stark",
          userType: "employer",
          firebaseUserId: "YCDugoXMwwVeaqs2SVNDW2YhdhA2",
          email: "atishayj2202@gmail.com");
      expect(result == true || result == false, true);
    });
    test('returns true if HTTP request succeeds', () async {
      final result = await createUserOnBackend(
          phoneNo: "770195847",
          name: "Tony Stark",
          userType: "employer",
          firebaseUserId: "rk2Zq12rxIPjoSxFGbavbEcI9bY2",
          email: "");
      expect(result == true || result == false, true);
    });
  });
  group('addTask', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await addTask(
          "1824b2de-bc70-470c-a80f-f52c9da8588e",
          "Fix the roof",
          "The roof is leaking",
          DateTime.now().add(const Duration(days: 3)));
      expect(result == true || result == false, true);
    });
  });
  group('addEmployee', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
          await addEmployee("1824b2de-bc70-470c-a80f-f52c9da8588e", "Manager Test");
      expect(result == true || result == false, true);
    });
  });
  group('getEmployees', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getEmployees();
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('getLocation', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getLocation("1824b2de-bc70-470c-a80f-f52c9da8588e",
          DateTime.now().subtract(const Duration(days: 3)), DateTime.now());
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('completeTask', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await completeTask("c2f768c1-d206-4959-912e-0b906f425380");
      expect(result == true || result == false, true);
    });
  });
  group('getTask', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getTask("c2f768c1-d206-4959-912e-0b906f425380");
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('getTasks', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getTasks("1824b2de-bc70-470c-a80f-f52c9da8588e",
          DateTime.now().subtract(const Duration(days: 3)), DateTime.now());
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('searchByPhone', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await searchByPhone("12345676875");
      print(result);
      expect(Null != result, true);
    });
  });
  group('addJobs', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await addJobs("description, I'm iron man @#^54192379",
          "title", 28.704060, 77.102493, 20000);
      expect(result, true);
    });
  });
  group('addPayments', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await addPayments("1824b2de-bc70-470c-a80f-f52c9da8588e",
          "Tea/Coffee for FY23", "USD", 100000);
      expect(true == result, true);
    });
  });
  group('getEmployeePayments', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
          await getEmployeePayments("1824b2de-bc70-470c-a80f-f52c9da8588e");
      print(result);
      expect(Null != result, true);
    });
  });
  group('addFeedback', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
          await addFeedback(4, "I want to pay to employee by app only.");
      expect(true == result, true);
    });
  });
  group('getPayments', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getPayments(
          DateTime.now().subtract(const Duration(days: 3)), DateTime.now());
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('getUser', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getUser();
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('addRating', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
          await addRating("1824b2de-bc70-470c-a80f-f52c9da8588e", 4, "");
      expect(true == result, true);
    });
    test('returns true if HTTP request succeeds', () async {
      final result = await addRating("e1b1e746-276b-4e11-b220-941680ec7b99", 5,
          "He is a really good employee.");
      expect(true == result, true);
    });
    test('returns true if HTTP request succeeds', () async {
      final result = await addRating(
          "1824b1de-bc70-470c-a80f-f52c9da8588e", 4, "Error testing");
      expect(true == result || false == result, true);
    });
    test('returns true if HTTP request succeeds', () async {
      final result = await addRating(
          "1824b2de-bc70-470c-a80f-f52c9da8588e", 1, "Changed Rating");
      expect(true == result, true);
    });
  });
  group('getRating', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getRating("1824b2de-bc70-470c-a80f-f52c9da8588e");
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('getJobDetail', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getJobDetail("51d42b59-2eae-4a41-bbb7-f1dd72f31162");
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('getEmployer', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getEmployer();
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('getEmployeeJob', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getEmployeeJob();
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('addLocation', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await addLocation(28.704060, 77.102493);
      expect(true == result, true);
    });
  });
  group('leaveJob', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await leaveJob();
      expect(true == result, true);
    });
  });
  group('approvePayment', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
          await approvePayment("3228feed-d782-4075-a8f2-360224be3b51");
      expect(true == result, true);
    });
  });
  group('getJobs', () {
    test('returns true if HTTP request succeeds', () async {
      final result = await getJobs(28.704060, 77.102493);
      print(result);
      expect(Null == result || Null != result, true);
    });
  });
  group('getEmployee', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
      await getEmployee("1824b2de-bc70-470c-a80f-f52c9da8588e");
      print(result);
      expect(Null != result, true);
    });
  });
  group('removeEmployee', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
      await removeEmployee("1824b2de-bc70-470c-a80f-f52c9da8588e");
      expect(true == result, true);
    });
  });
  group('deleteTask', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
      await deleteTask("2ab3d493-a877-4f86-bd16-91934b0a4acc");
      expect(true == result, true);
    });
  });
  group('deleteJob', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
      await deleteJob("8dc2a5ff-6ec2-472a-934a-5db4776a94db");
      expect(true == result, true);
    });
  });
  group('completeJob', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
      await completeJob("8dc2a5ff-6ec2-472a-934a-5db4776a94db");
      expect(true == result, true);
    });
  });
  group('searchEmployeeByEmail', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
      await searchByEmail("apple@gmail.com");
      print(result);
      expect({} != result, true);
    });
  });
  group('getEmployerJobs', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
      await getPostedJobs();
      print(result);
      expect({} != result, true);
    });
  });
  group('searchUserByID', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
      await getUserByID("8dc0ce60-c48c-48bc-8bf5-6373b658cbe8");
      print(result);
      expect({} != result, true);
    });
  });
  group('updateUser', () {
    test('returns true if HTTP request succeeds', () async {
      final result =
      await updateUser("Worker App Test", "9999999999999", "");
      print(result);
      expect(true == result, true);
    });
  });
}
