package model;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BasketDAO {
	//장바구니 삽입
	public static int insertBasket(String userId, String productId) {
        String query = "{call insert_basket(?,?,?)}";
        int result = -1;
        
        try(Connection connection = DatabaseUtil.getConnection();
        		CallableStatement cstmt = connection.prepareCall(query)){
        	cstmt.setString(1, userId);
        	cstmt.setInt(2, Integer.parseInt(productId));
        	cstmt.registerOutParameter(3, Types.INTEGER);
        	cstmt.execute();
        	
        	result = cstmt.getInt(3);
        } catch(SQLException e) {
        	e.printStackTrace();
        }
        return result;
	}
	//특정 유저의 basket에 특정 아이템 존재 여부 조회.
		//stored procedure, cursor, IF
		public static boolean isInBasket(String userId, String productId) {
			String query = "{call check_basket(?,?,?)}";
			
			try (Connection connection = DatabaseUtil.getConnection();
					CallableStatement cstmt = connection.prepareCall(query);
				){
				cstmt.setString(1, userId);
				cstmt.setInt(2, Integer.parseInt(productId));
				cstmt.registerOutParameter(3, Types.NUMERIC);
				cstmt.execute();
				
				boolean inBasket =  (cstmt.getInt(3)==1);
				
				DatabaseUtil.closeConnection();
				return inBasket;
				
			}catch (SQLException e) {
				e.printStackTrace();
			}
			return false;
		}
	    //장바구니 프로덕트 정보 조회
	    public static List<ProductDTO> getBasketProducts(String userId){
	    	List<ProductDTO> products = new ArrayList<>();
	    	String sql = "SELECT product_id, product_name, price, product_image " +
                    "FROM PRODUCT " +
                    "WHERE product_id IN (SELECT product_id FROM BASKET WHERE user_id = ?)";
	    	try (Connection connection = DatabaseUtil.getConnection();
	    			PreparedStatement pstmt = connection.prepareStatement(sql);
				){
                pstmt.setString(1, userId);
                ResultSet resultSet = pstmt.executeQuery();
                while(resultSet.next()) {
                	ProductDTO product = new ProductDTO();
        			product.setId(resultSet.getString("product_id"));
        			product.setName(resultSet.getString("product_name"));
        			product.setPrice(resultSet.getDouble("price"));
        			product.setProduct_image(resultSet.getString("product_image"));
        			products.add(product);
                }
				
				DatabaseUtil.closeConnection();
			}catch (SQLException e) {
				e.printStackTrace();
			}
	    	return products;
	    }
	    //장바구니 삭제
	    public static boolean deleteBasket(String userId, String productId) {
	    	String sql = "DELETE FROM BASKET WHERE user_id = ? AND product_id = ?";
	    	try(Connection connection = DatabaseUtil.getConnection();
	    			PreparedStatement pstmt = connection.prepareStatement(sql);){
	            pstmt.setString(1, userId);
	            pstmt.setString(2, productId);
	            int rowsAffected = pstmt.executeUpdate();

	            if (rowsAffected > 0) return true;
	            else return false;
	    	} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	return false;
	    }
}
