package org.example;

import java.sql.*;
import java.util.List;

public class Main {

    public static void main(String[] args)throws Exception {
        DBconn db = new DBconn();
//        db.createTables();
//        List<List<String>> owners = List.copyOf(
//            List.of(
//                List.of("1","Malek", "Khaled", "Ilidza"),
//                List.of("2","Malek", "Man", "Ilidza"),
//                List.of("3","Khaled", "Mohamed", "Ilidza")
//            )
//        );
//        db.insertOwners(owners);

//        List<List<String>> cars = List.copyOf(
//            List.of(
//                List.of("1","KIA", "2022-01-01", "1"),
//                List.of("2","BMW", "2023-01-01", "2"),
//                List.of("3","Mitsubishi", "2024-01-01", "3")
//            )
//        );
//        db.insertcars(cars);
        db.getCarAndOwnerNames(1);
//        db.deleteOwner(3);
        db.updateCarName(1, "KIA");
        db.getCarAndOwnerNames(1);
    }
}

class DBconn {
    Connection con;

    public DBconn() throws Exception {
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lab_fgroup", "root","1234");
    }

    public void createTables() throws Exception {
        createTable("CREATE TABLE Owner (" +
                "owner_id INTEGER PRIMARY KEY, first_name VARCHAR(255), last_name VARCHAR(255), address VARCHAR(255))");
        createTable("CREATE TABLE Cars (" +
                "car_id INT PRIMARY KEY, name VARCHAR(255), registration DATE, owner_id INTEGER, " +
                "FOREIGN KEY (owner_id) REFERENCES Owner(owner_id))");
    }

    public void createTable(String query) throws Exception{
        Statement stmt = con.createStatement();
        stmt.executeUpdate(query);
        stmt.close();
    }

    public void insertOwners(List<List<String>> values) throws SQLException{
        String query= "INSERT INTO Owner (owner_id, first_name, last_name , address) VALUES (?,?,?,?)";
        PreparedStatement stmt = con.prepareStatement(query);
        int count = 0;
        for (List<String> value: values) {
            stmt.setInt(1, Integer.parseInt(value.get(0)));
            stmt.setString(2, value.get(1));
            stmt.setString(3, value.get(2));
            stmt.setString(4, value.get(3));
            count += stmt.executeUpdate();
        }
        System.out.println("rows inserted " + count);
        stmt.close();
    }

    public void insertcars(List<List<String>> values) throws Exception {
        String query = "INSERT INTO cars (car_id, name, registration, owner_id) VALUES (?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(query);
        int counter = 0;
        for(List<String> value:values){
            stmt.setInt(1, Integer.parseInt(value.get(0)));
            stmt.setString(2, value.get(1));
            stmt.setDate(3, Date.valueOf(value.get(2)));
            stmt.setInt(4, Integer.parseInt(value.get(3)));

            counter += stmt.executeUpdate();
        }
        System.out.println("rows " + counter);
        stmt.close();
    }

    public void getCarAndOwnerNames(int carId) throws Exception {
        String query = "SELECT c.name AS car_name, CONCAT(o.first_name, ' ' , o.last_name) AS owner_name FROM cars c " +
                "JOIN owner o ON o.owner_id = c.owner_id " +
                "WHERE c.car_id = ?";
        PreparedStatement statement = con.prepareStatement(query);
        statement.setInt(1, carId);

        ResultSet rs = statement.executeQuery();

        while(rs.next()){
            System.out.println("car name: "  + rs.getString("car_name"));
            System.out.println("owner name: "  + rs.getString("owner_name"));
        }
        statement.close();
    }

    public void deleteOwner(int ownerId) throws Exception {
        String query = "DELETE FROM owner WHERE owner.owner_id = ?";
        PreparedStatement statement = con.prepareStatement(query);
        statement.setInt(1, ownerId);

        int counter = statement.executeUpdate();
        System.out.println("rows " + counter + " deleted");
        statement.close();
    }

    public void updateCarName(int carId, String newName) throws Exception {
        String query = "UPDATE cars SET name = ? WHERE car_id = ?";
        PreparedStatement statement = con.prepareStatement(query);
        statement.setString(1, newName);
        statement.setInt(2, carId);

        int counter = statement.executeUpdate();
        statement.close();
        System.out.println("rows " + counter + " updated");
    }
}