import { BsPersonCircle } from 'react-icons/bs'
import './sidebar.css'
import { useNavigate } from 'react-router-dom';
import BalanceModal from '../Modals/BalanceModal';

function Sidebar(props){
    const { currentUser, handleModuleSelection, module, showWithdrawModal, setShowWithdrawModal, showDepositModal, setShowDepositModal, depositAmount, setDepositAmount, withdrawAmount, setWithdrawAmount, handleDeposit, handleWithdraw } = props;

    const navigate = useNavigate();

    const handleLogout = () => {
        localStorage.removeItem('currentUser');
        navigate('/');
    }

    return(
        <>

        {(showWithdrawModal || showDepositModal) && (
            <BalanceModal
                currentUser={currentUser} 
                showWithdrawModal={showWithdrawModal}
                setShowWithdrawModal={setShowWithdrawModal}
                showDepositModal={showDepositModal}
                setShowDepositModal={setShowDepositModal}
                depositAmount={depositAmount}
                setDepositAmount={setDepositAmount}
                withdrawAmount={withdrawAmount}
                setWithdrawAmount={setWithdrawAmount}
                handleDeposit={handleDeposit}
                handleWithdraw={handleWithdraw}
            />
        )}

        <nav className="sidebar">
            <div className="avatar_container">
                <BsPersonCircle className={`avatar_logo ${currentUser.role === "admin" ? "avatar_admin" : ""}`} />
                <div className="avatar_text">
                    <h4>{currentUser.first_name}</h4>
                    <h6>{currentUser.role}</h6>
                </div>
            </div>
            {currentUser.role === "trader" ? 
            <a className='sidebar_btn balance_container'>
                <span>₱{currentUser.balance.toFixed(2)}</span>
                <div className="balance_action">
                    <span className='btns btn_primary' onClick={() => setShowWithdrawModal(true)}>Withdraw</span>
                    <span className='btns btn_primary' onClick={() => setShowDepositModal(true)}>Deposit</span>    
                </div>
            </a> 
            : null }
            <button
                className={`btns ${module === 'Stocks' ? 'btn_secondary' : 'btn_primary'} sidebar_btn`}
                onClick={() => handleModuleSelection('Stocks')}
            >
                Stock List
            </button>
            {currentUser.role === "admin" ? 
            <button 
                className={`btns ${module === 'Traders' ? 'btn_secondary' : 'btn_primary'} sidebar_btn`}
                onClick={() => handleModuleSelection('Traders')}
            >
                Traders
            </button> 
            : null }
            {currentUser.role === "trader" ? 
            <button 
                className={`btns ${module === 'Portfolios' ? 'btn_secondary' : 'btn_primary'} sidebar_btn`}
                onClick={() => handleModuleSelection('Portfolios')}
            >
                Portfolio
            </button> 
            : null }
            <button
                className={`btns ${module === 'Transactions' ? 'btn_secondary' : 'btn_primary'} sidebar_btn`}
                onClick={() => handleModuleSelection('Transactions')}
            >
                Transactions
            </button>
            <button className='btns btn_primary sidebar_btn signout_btn' onClick={handleLogout}>
                Sign Out
            </button>
        </nav>
        </>
    )
}

export default Sidebar;