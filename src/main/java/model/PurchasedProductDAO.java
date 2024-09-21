package model;

import java.sql.*;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class PurchasedProductDAO {
	//history�� (userId, product_id) ��ȸ.
		//stored procedure, cursor, IF
		public static boolean isInHistory(String userId, String productId) {
			String query = "{call check_history(?,?,?)}";
			
			try (Connection connection = DatabaseUtil.getConnection();
					CallableStatement cstmt = connection.prepareCall(query);
				){
				cstmt.setString(1, userId);
				cstmt.setInt(2, Integer.parseInt(productId));
				cstmt.registerOutParameter(3, Types.NUMERIC);
				cstmt.execute();
				
				boolean inHistory =  (cstmt.getInt(3)==1);
				
				DatabaseUtil.closeConnection();
				return inHistory;
				
			}catch (SQLException e) {
				e.printStackTrace();
			}
			return false;
		}
    //������ ���δ�Ʈ ���� ��������
    //stored procedure, callable statement, join, null ó��, VIEW
    public static List<PurchasedProductDTO> getUserProducts(String userId) {
        List<PurchasedProductDTO> products = new ArrayList<>();
        String sql = "SELECT product_id, product_name, author, product_image, created_date FROM purchased_product where user_id = ?";

        try (Connection connection = DatabaseUtil.getConnection();
        		PreparedStatement pstmt = connection.prepareStatement(sql);) {
        	pstmt.setString(1, userId);
        	
        	ResultSet rs = pstmt.executeQuery();
        		while (rs.next()) {
        			PurchasedProductDTO product = new PurchasedProductDTO();
        			product.setId(rs.getString("product_id"));
        			product.setName(rs.getString("product_name"));
        			product.setAuthor(rs.getString("author"));
        			product.setProduct_image(rs.getString("product_image"));
        			product.setPurchased_date(rs.getString("created_date"));
        			products.add(product);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // ���� ó��
        }

        DatabaseUtil.closeConnection();
        return products;
    }
    //����id ���� history ��ȸ
    public static List<List<PurchasedProductDTO>> getHistoryByOrderId(String userId) {
        String sql = "SELECT h.order_id, h.status_name, p.product_id, p.product_name " // �ʿ��� �÷����� ��� ����
                   + "FROM HISTORY h JOIN PRODUCT p ON h.product_id = p.product_id "
                   + "WHERE h.user_id = ? "
                   + "ORDER BY h.order_id"; // order_id ������ ����

        List<List<PurchasedProductDTO>> orderList = new ArrayList<>(); // ���� ��ȯ ����Ʈ
        List<PurchasedProductDTO> currentOrder = null; // ���� order_id�� �ش��ϴ� ��ǰ ����Ʈ
        int currentOrderId = -1; // �ʱⰪ -1�� ����

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql)) {

            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int orderId = rs.getInt("order_id");
                String status = rs.getString("status_name");

                // ���ο� �ֹ���ȣ�� ��Ÿ���� ���ο� ����Ʈ�� ����
                if (orderId != currentOrderId) {
                    if (currentOrder != null) {
                        // ���� �ֹ���ȣ�� ���� ����Ʈ�� ���� ����Ʈ�� �߰�
                        orderList.add(currentOrder);
                    }
                    // �� ����Ʈ ����
                    currentOrder = new ArrayList<>();
                    currentOrderId = orderId; // ���� order_id ������Ʈ
                }

                // ���� �ֹ���ȣ�� �ش��ϴ� ��ǰ �߰�
                PurchasedProductDTO product = new PurchasedProductDTO();
                product.setOrder_id(String.valueOf(orderId));
                product.setStatus_name(status);
                product.setId(rs.getString("product_id"));
                product.setName(rs.getString("product_name"));

                currentOrder.add(product);
            }

            // ������ �ֹ��� ���� ����Ʈ �߰�
            if (currentOrder != null) {
                orderList.add(currentOrder);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderList;
    }
    //ȯ���ϱ�
    public static String updateStatusRefund(String userId, String orderId) {
        String sql = "{call refund_products(?, ?, ?)}"; // OUT �Ķ���� �߰�
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall(sql)) {

            // IN �Ķ���� ����
            cstmt.setString(1, userId);
            cstmt.setInt(2, Integer.parseInt(orderId));
            
            // OUT �Ķ���� ����
            cstmt.registerOutParameter(3, Types.VARCHAR); // OUT �Ķ���ͷ� result_message ���

            // ���ν��� ����
            cstmt.execute();

            // OUT �Ķ���Ϳ��� result_message ���� ������
            String resultMessage = cstmt.getString(3);

            return resultMessage;

        } catch (SQLException e) {
            e.printStackTrace();
            return "ȯ���� �����Ͽ����ϴ�.";
        }
    }

}
