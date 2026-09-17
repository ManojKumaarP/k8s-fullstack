package com.example.employee;

import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/employees")
public class EmployeeController {

    private final List<Employee> employees = new ArrayList<>();

    public EmployeeController() {

        employees.add(
            new Employee(1L, "John", "Developer", "IT")
        );

        employees.add(
            new Employee(2L, "Alice", "Tester", "QA")
        );
    }

    @GetMapping
    public List<Employee> getEmployees() {
        return employees;
    }

    @GetMapping("/{id}")
    public Employee getEmployee(@PathVariable Long id) {

        return employees.stream()
                .filter(employee -> employee.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @PostMapping
    public Employee createEmployee(@RequestBody Employee employee) {

        employee.setId((long) (employees.size() + 1));

        employees.add(employee);

        return employee;
    }
}