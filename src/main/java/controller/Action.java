package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.*;

public interface Action {
    void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
}
