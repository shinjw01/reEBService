package model;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
	//모든 프로덕트 정보 가져오기
	//stored procedure, callable statement, null처리
	public static List<ProductDTO> getAllProducts() {
	    List<ProductDTO> products = new ArrayList<>();
	    String query = "{call get_products(?)}";  // MySQL 프로시저 호출, OUT 파라미터 없음

	    try (Connection connection = DatabaseUtil.getConnection();
	         CallableStatement cstmt = connection.prepareCall(query)) {
	        
	        // 첫 번째 IN 매개변수 설정 (NULL일 경우 전체 상품 조회)
	        cstmt.setString(1, null);
	        
	        // 쿼리 실행
	        try (ResultSet resultSet = cstmt.executeQuery()) {
	            // 결과 집합을 순회하면서 ProductDTO 리스트에 추가
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
	        e.printStackTrace(); // 에러 처리
	    }

	    DatabaseUtil.closeConnection();  // 연결 종료
	    return products;
	}

    
    //한 프로덕트 정보 가져오기
    //stored function, callable statement, Null값 처리 
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
            // SQLException 처리
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } catch (NumberFormatException e) {
            // NumberFormatException 처리
            System.err.println("Invalid product ID format: " + product_id);
            e.printStackTrace();
        }

        return product;
    }
    
    // 프로덕트 구매 처리
    public static String purchaseProduct(String userId, String[] productIds) {
        String query = "{CALL purchase_product(?, ?, ?)}";  // 저장 프로시저 호출
        try (Connection connection = DatabaseUtil.getConnection();
             CallableStatement cstmt = connection.prepareCall(query)) {

            // 쉼표로 구분된 productIds 문자열 생성
            String productIdsStr = String.join(",", productIds);

            // IN 파라미터 설정
            cstmt.setString(1, userId);       // 첫 번째 파라미터: 사용자 ID
            cstmt.setString(2, productIdsStr); // 두 번째 파라미터: 쉼표로 구분된 상품 ID들

            // OUT 파라미터 설정
            cstmt.registerOutParameter(3, Types.VARCHAR);  // 세 번째 파라미터: 결과 메시지

            // 프로시저 실행
            cstmt.execute();

            // 결과 메시지 가져오기
            String resultMessage = cstmt.getString(3);
            System.out.println("Result: " + resultMessage);

            return resultMessage;

        } catch (SQLException e) {
            e.printStackTrace();
            return "문제가 발생했습니다.";
        }
    }


}

