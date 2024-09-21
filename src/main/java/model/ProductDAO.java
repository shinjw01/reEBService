package model;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
	//��� ���δ�Ʈ ���� ��������
	//stored procedure, callable statement, nulló��
	public static List<ProductDTO> getAllProducts() {
	    List<ProductDTO> products = new ArrayList<>();
	    String query = "{call get_products(?)}";  // MySQL ���ν��� ȣ��, OUT �Ķ���� ����

	    try (Connection connection = DatabaseUtil.getConnection();
	         CallableStatement cstmt = connection.prepareCall(query)) {
	        
	        // ù ��° IN �Ű����� ���� (NULL�� ��� ��ü ��ǰ ��ȸ)
	        cstmt.setString(1, null);
	        
	        // ���� ����
	        try (ResultSet resultSet = cstmt.executeQuery()) {
	            // ��� ������ ��ȸ�ϸ鼭 ProductDTO ����Ʈ�� �߰�
	            while (resultSet.next()) {
	                ProductDTO product = new ProductDTO();
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

	    DatabaseUtil.closeConnection();  // ���� ����
	    return products;
	}

    
    //�� ���δ�Ʈ ���� ��������
    //stored function, callable statement, Null�� ó�� 
    public static ProductDTO getProduct(String product_id) {
        ProductDTO product = null;
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

            product = new ProductDTO();
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

        return product;
    }
    
    // ���δ�Ʈ ���� ó��
    public static String purchaseProduct(String userId, String[] productIds) {
        String query = "{CALL purchase_product(?, ?, ?)}";  // ���� ���ν��� ȣ��
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall(query)) {

            // ��ǥ�� ���е� productIds ���ڿ� ����
            String productIdsStr = String.join(",", productIds);

            // IN �Ķ���� ����
            cstmt.setString(1, userId);       // ù ��° �Ķ����: ����� ID
            cstmt.setString(2, productIdsStr); // �� ��° �Ķ����: ��ǥ�� ���е� ��ǰ ID��

            // OUT �Ķ���� ����
            cstmt.registerOutParameter(3, Types.VARCHAR);  // �� ��° �Ķ����: ��� �޽���

            // ���ν��� ����
            cstmt.execute();

            // ��� �޽��� ��������
            String resultMessage = cstmt.getString(3);
            System.out.println("Result: " + resultMessage);

            return resultMessage;

        } catch (SQLException e) {
            e.printStackTrace();
            return "������ �߻��߽��ϴ�.";
        }
    }


}

