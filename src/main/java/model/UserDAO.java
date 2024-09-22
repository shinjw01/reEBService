package model;
import java.sql.*;
public class UserDAO {
	//user 생성
	public static int createUser(UserDTO user) {
		int result = 0;
		String sql = "INSERT INTO USERS (user_name, user_id, email, password, birth, phone) VALUES (?, ?, ?, ?, ?, ?)";
		try(Connection connection = DatabaseUtil.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(sql);){
			pstmt.setString(1, user.getName());
	        pstmt.setString(2, user.getId());
	        pstmt.setString(3, user.getEmail());
	        pstmt.setString(4, user.getPassword());
	        pstmt.setString(5, user.getBirth());
	        pstmt.setString(6, user.getPhone());

	        result = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	//user id 여부 조회
	public static int getUserId(String userId) {
		int count = 1;
		String sql = "SELECT COUNT(*) FROM USERS WHERE user_id = ?";
		try(Connection connection = DatabaseUtil.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(sql);){
			pstmt.setString(1, userId);
			ResultSet rs = pstmt.executeQuery();
			rs.next();
            count = rs.getInt(1);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return count;
	}
	//user point 조회
	public static String getUserPoint(String userId) {
        String sql = "SELECT point FROM USERS WHERE user_id = ?";
        String result = "";
		try(Connection connection = DatabaseUtil.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(sql);){
			pstmt.setString(1, userId);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next())
				result = rs.getString("point");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	public static UserDTO getUserDTO(String userId, String password) {
		String sql = "SELECT user_id, user_name, point FROM USERS WHERE user_id = ? AND password = ?";
		try(Connection connection = DatabaseUtil.getConnection();
				PreparedStatement pstmt = connection.prepareStatement(sql)){
			pstmt.setString(1, userId);
	        pstmt.setString(2, password);
	        ResultSet rs = pstmt.executeQuery();
	        if(rs.next()) {
	        	UserDTO user = new UserDTO();
	        	user.setId(userId);
	        	user.setName(rs.getString("user_name"));
	        	user.setPoint(rs.getInt("point"));
	        	return user;
	        }
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}
