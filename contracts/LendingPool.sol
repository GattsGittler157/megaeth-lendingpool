// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LendingPool is Ownable {
    IERC20 public token;        // токен, который принимает пул
    uint256 public totalDeposits;
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public borrowings;

    uint256 public depositInterestRate; // годовой процент (в базовых пунктах, например 500 = 5.00%)
    uint256 public borrowInterestRate;  // годовой процент для займщиков

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event Borrowed(address indexed user, uint256 amount);
    event Repaid(address indexed user, uint256 amount);

    constructor(IERC20 _token, uint256 _depositInterestRate, uint256 _borrowInterestRate) {
        token = _token;
        depositInterestRate = _depositInterestRate;
        borrowInterestRate = _borrowInterestRate;
    }

    // Пользователь вносит средства
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must > 0");
        token.transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] += amount;
        totalDeposits += amount;
        emit Deposited(msg.sender, amount);
    }

    // Пользователь выводит все свои средства + начисленные проценты
    function withdraw() external {
        uint256 amount = deposits[msg.sender];
        require(amount > 0, "Nothing to withdraw");
        // Простая модель: начисляем процент один раз при выводе
        uint256 interest = (amount * depositInterestRate) / 10000;
        uint256 payout = amount + interest;
        require(token.balanceOf(address(this)) >= payout, "Insufficient pool balance");
        deposits[msg.sender] = 0;
        totalDeposits -= amount;
        token.transfer(msg.sender, payout);
        emit Withdrawn(msg.sender, payout);
    }

    // Пользователь берёт займ под залог — в упрощённой версии просто записываем, без залога
    function borrow(uint256 amount) external {
        require(amount > 0, "Amount must > 0");
        require(token.balanceOf(address(this)) >= amount, "Insufficient pool liquidity");
        borrowings[msg.sender] += amount;
        token.transfer(msg.sender, amount);
        emit Borrowed(msg.sender, amount);
    }

    // Пользователь возвращает займ + процент
    function repay(uint256 amount) external {
        require(amount > 0, "Amount must > 0");
        require(borrowings[msg.sender] >= amount, "Repay > borrowed");
        token.transferFrom(msg.sender, address(this), amount);
        // На проценты не начисляем отдельно — просто уменьшаем долг
        borrowings[msg.sender] -= amount;
        emit Repaid(msg.sender, amount);
    }

    // Владелец может пополнять пул токенами (например, чтобы обеспечить ликвидность)
    function fundPool(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount > 0");
        token.transferFrom(msg.sender, address(this), amount);
    }

    // Владелец может установить новые ставки
    function setRates(uint256 _depositInterestRate, uint256 _borrowInterestRate) external onlyOwner {
        depositInterestRate = _depositInterestRate;
        borrowInterestRate = _borrowInterestRate;
    }
}
