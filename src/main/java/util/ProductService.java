package util;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductService {
	//����Ʈ �������� ������ ���� �ҷ�����
	//stored procedure, callable statement, nulló��
    public static List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String query = "{call get_products(?,?)}";

        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall(query);
             ) {
        	cstmt.setString(1, null);
        	cstmt.registerOutParameter(2, Types.REF_CURSOR);
        	cstmt.execute();
        	try (ResultSet resultSet =  (ResultSet) cstmt.getObject(2)){
        		while (resultSet.next()) {
        			Product product = new Product();
        			product.setId(resultSet.getString("product_id"));
        			product.setName(resultSet.getString("product_name"));
        			product.setAuthor(resultSet.getString("author"));
        			product.setProduct_image(resultSet.getString("product_image"));
        			products.add(product);
            }
            }

        } catch (SQLException e) {
            e.printStackTrace(); // ���� ó��
        }
        
        DatabaseUtil.closeConnection();
        return products;
    }
    
    //���� �������� ������ ���� �ҷ�����
    //stored procedure, callable statement, join, null ó��, VIEW
    public static List<PurchasedProduct> getUserProducts(String userId) {
        List<PurchasedProduct> products = new ArrayList<>();
        String query = "{call get_products(?,?)}";

        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall(query);
             ) {
        	cstmt.setString(1, userId);
        	cstmt.registerOutParameter(2, Types.REF_CURSOR);
        	cstmt.execute();
        	try (ResultSet resultSet =  (ResultSet) cstmt.getObject(2)){
        		while (resultSet.next()) {
        			PurchasedProduct product = new PurchasedProduct();
        			product.setId(resultSet.getString("product_id"));
        			product.setName(resultSet.getString("product_name"));
        			product.setAuthor(resultSet.getString("author"));
        			product.setProduct_image(resultSet.getString("product_image"));
        			product.setPurchased_date(resultSet.getString("created_date"));
        			products.add(product);
            }
            }

        } catch (SQLException e) {
            e.printStackTrace(); // ���� ó��
        }

        DatabaseUtil.closeConnection();
        return products;
    }
    //�������� ǥ���� ����
    //stored function, callable statement, Null�� ó�� 
    public static Product getProduct(String product_id) {
        Product product = null;
        String query = "{ CALL get_product(?, ?, ?, ?, ?, ?, ?, ?, ?) }";

        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement callableStatement = connection.prepareCall(query)) {

            callableStatement.setInt(1, Integer.parseInt(product_id));
            callableStatement.registerOutParameter(2, Types.INTEGER);
            callableStatement.registerOutParameter(3, Types.VARCHAR);
            callableStatement.registerOutParameter(4, Types.DOUBLE);
            callableStatement.registerOutParameter(5, Types.VARCHAR);
            callableStatement.registerOutParameter(6, Types.VARCHAR);
            callableStatement.registerOutParameter(7, Types.VARCHAR);
            callableStatement.registerOutParameter(8, Types.VARCHAR);
            callableStatement.registerOutParameter(9, Types.VARCHAR);

            callableStatement.execute();

            product = new Product();
            product.setId(String.valueOf(callableStatement.getInt(2)));
            product.setName(callableStatement.getString(3));
            product.setPrice(callableStatement.getDouble(4));
            product.setDetail(callableStatement.getString(5));
            product.setPublished_date(callableStatement.getString(6));
            product.setPublisher(callableStatement.getString(7));
            product.setProduct_image(callableStatement.getString(8));
            product.setAuthor(callableStatement.getString(9));
            
            if (product.getId().equals("0")) {
            	product = null;
            	}
            
        } catch (SQLException e) {
            // SQLException ó��
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } catch (NumberFormatException e) {
            // NumberFormatException ó��
            System.err.println("Invalid product ID format: " + product_id);
            e.printStackTrace();
        }

        DatabaseUtil.closeConnection();
        return product;
    }

}

