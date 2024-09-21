package model;

import java.sql.*;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class PurchasedProductDAO {
	//history에 (userId, product_id) 조회.
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
    //구매한 프로덕트 정보 가져오기
    //stored procedure, callable statement, join, null 처리, VIEW
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
            e.printStackTrace(); // 에러 처리
        }

        DatabaseUtil.closeConnection();
        return products;
    }
    //구매id 별로 history 조회
    public static List<List<PurchasedProductDTO>> getHistoryByOrderId(String userId) {
        String sql = "SELECT h.order_id, h.status_name, p.product_id, p.product_name " // 필요한 컬럼들을 모두 선택
                   + "FROM HISTORY h JOIN PRODUCT p ON h.product_id = p.product_id "
                   + "WHERE h.user_id = ? "
                   + "ORDER BY h.order_id"; // order_id 순으로 정렬

        List<List<PurchasedProductDTO>> orderList = new ArrayList<>(); // 최종 반환 리스트
        List<PurchasedProductDTO> currentOrder = null; // 현재 order_id에 해당하는 상품 리스트
        int currentOrderId = -1; // 초기값 -1로 설정

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql)) {

            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int orderId = rs.getInt("order_id");
                String status = rs.getString("status_name");

                // 새로운 주문번호가 나타나면 새로운 리스트를 생성
                if (orderId != currentOrderId) {
                    if (currentOrder != null) {
                        // 이전 주문번호에 대한 리스트를 최종 리스트에 추가
                        orderList.add(currentOrder);
                    }
                    // 새 리스트 생성
                    currentOrder = new ArrayList<>();
                    currentOrderId = orderId; // 현재 order_id 업데이트
                }

                // 현재 주문번호에 해당하는 상품 추가
                PurchasedProductDTO product = new PurchasedProductDTO();
                product.setOrder_id(String.valueOf(orderId));
                product.setStatus_name(status);
                product.setId(rs.getString("product_id"));
                product.setName(rs.getString("product_name"));

                currentOrder.add(product);
            }

            // 마지막 주문에 대한 리스트 추가
            if (currentOrder != null) {
                orderList.add(currentOrder);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderList;
    }
    //환불하기
    public static String updateStatusRefund(String userId, String orderId) {
        String sql = "{call refund_products(?, ?, ?)}"; // OUT 파라미터 추가
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall(sql)) {

            // IN 파라미터 설정
            cstmt.setString(1, userId);
            cstmt.setInt(2, Integer.parseInt(orderId));
            
            // OUT 파라미터 설정
            cstmt.registerOutParameter(3, Types.VARCHAR); // OUT 파라미터로 result_message 등록

            // 프로시저 실행
            cstmt.execute();

            // OUT 파라미터에서 result_message 값을 가져옴
            String resultMessage = cstmt.getString(3);

            return resultMessage;

        } catch (SQLException e) {
            e.printStackTrace();
            return "환불이 실패하였습니다.";
        }
    }

}
