import { useTable, usePagination, useGlobalFilter, useSortBy } from 'react-table';
import { BsArrowLeft, BsArrowRight } from 'react-icons/bs';
import TableModal from "../../components/Modals/TableModal";
import AuthModal from "../../components/Modals/AuthModal";
import './table.css'
import { useEffect } from 'react';

function Table(props) {
    const { currentUser, setCurrentUser, columns, data, table_header, date, setShowModal, fetchData, showStockModal, selectedStock, showTraderModal, selectedTrader, showCreateTrader, setShowCreateTrader, traders, updateTrader, setPortfolioUpdated, selectedStatus, handleStatusChange, loading, setLoading } = props;

    const desktopPageSize = 11;
    const tabletPageSize = 10;
    const mobilePageSize = 5;
    
    const getInitialPageSize = () => {
        if (window.innerWidth <= 768) return mobilePageSize;
        if (window.innerWidth <= 1024) return tabletPageSize;
        return desktopPageSize;
    };

    const {
        getTableProps,
        getTableBodyProps,
        headerGroups,
        page,
        prepareRow,
        state: { pageIndex, globalFilter, pageSize },
        canPreviousPage,
        canNextPage,
        pageOptions,
        gotoPage,
        nextPage,
        previousPage,
        setGlobalFilter,
        setPageSize
    } = useTable(
        {
            columns,
            data,
            initialState: {
                pageIndex: 0,
                pageSize: getInitialPageSize(),
                sortBy: [
                    {
                        id: 'id',
                        desc: false, // Ascending order
                    },
                ],
            },
        },
    useGlobalFilter,
    useSortBy,
    usePagination 
    );

    useEffect(() => {
        const handleResize = () => {
            const newPageSize = getInitialPageSize();
            if (newPageSize !== pageSize) {
                setPageSize(newPageSize);
            }
        };

        window.addEventListener('resize', handleResize);
        return () => {
            window.removeEventListener('resize', handleResize);
        };
    }, [pageSize, setPageSize]);

    return (
        <>
            <div className="utilTable_container">

                {showStockModal && (
                    <TableModal
                        showStockModal={showStockModal}
                        setShowStockModal={setShowModal}
                        stockData={selectedStock}
                        currentUser={currentUser}
                        setCurrentUser={setCurrentUser}
                        table_header={table_header}
                        setPortfolioUpdated={setPortfolioUpdated}
                    />
                )}

                {showTraderModal && (
                    <TableModal
                        showTraderModal={showTraderModal}
                        setShowTraderModal={setShowModal}
                        traderData={selectedTrader}
                        updateTrader={updateTrader}
                        loading={loading}
                        setLoading={setLoading}
                    />
                )}

                {showCreateTrader && (
                    <AuthModal
                        currentUser={currentUser} 
                        traders={traders}
                        showCreateTrader={showCreateTrader}
                        setShowCreateTrader={setShowCreateTrader}
                    />
                )}
                    
                <div style={{display: "flex", justifyContent: "space-between", alignItems: "center"}} className='table_header_wrapper'>
                    <div className="table_header_container">
                        <h1>{table_header}</h1>
                        {table_header === "TRADERS" && 
                        <button
                            style={{padding: "0"}}     
                            className="btns btn_secondary" 
                            onClick={() => setShowCreateTrader(true)}
                        >
                            Create Trader
                        </button>}
                    </div>
                    
                    <div className="search_container">
                        <input
                            type="text"
                            value={globalFilter || ''}
                            onChange={(e) => setGlobalFilter(e.target.value)}
                            placeholder="Search by name..."
                        />
                        {date && <span>As of: {date}</span>}
                        {table_header === "TRADERS" && (
                            <div className="filter">
                                <label>Status Filter:</label>
                                <select value={selectedStatus} onChange={handleStatusChange}>
                                    <option value="all">All</option>
                                    <option value="pending">Pending</option>
                                    <option value="approved">Approved</option>
                                </select>
                            </div>
                        )}
                        
                    </div>
                </div>

                <div className="table_container">
                <table className='utilTable' {...getTableProps()}>
                    <thead>
                        {headerGroups.map((headerGroup) => (
                            <tr {...headerGroup.getHeaderGroupProps()}>
                                {headerGroup.headers.map((column) => (
                                    <th {...column.getHeaderProps()}>
                                        {column.render("Header")}
                                    </th>
                                ))}
                            </tr>
                        ))}
                    </thead>
                    <tbody {...getTableBodyProps()}>
                        {page.map((row) => {
                            prepareRow(row)
                            return(
                                <tr
                                    onClick={() => {
                                        if (table_header !== "TRANSACTIONS") {
                                            setShowModal(true);
                                            fetchData(row.original.id);
                                            if (table_header === "PORTFOLIOS") {
                                                setPortfolioUpdated(false);
                                            }
                                        }
                                    }}
                                    {...row.getRowProps()}
                                >
                                    {row.cells.map((cell) => (
                                        <td {...cell.getCellProps()}>
                                            {cell.render("Cell")}
                                        </td>
                                    ))}
                                </tr>
                            )
                        })}
                    </tbody>
                </table>
                </div>

                {/* Pagination controls */}
                <div className="pagination">
                    <button className='btns btn_secondary' onClick={() => previousPage()} disabled={!canPreviousPage}>
                        <BsArrowLeft />
                    </button>
                    <button className='btns btn_secondary' onClick={() => nextPage()} disabled={!canNextPage}>
                        <BsArrowRight />
                    </button>
                    <span>Page {pageIndex + 1} of {pageOptions.length}</span>
                    <span className='pagination_divider'>|</span>
                    <div className='pagination_go_to'>
                        <span>GO TO PAGE : </span> 
                        <input
                            type="number"
                            defaultValue={pageIndex + 1}
                            onChange={(e) => {
                                const page = e.target.value ? Number(e.target.value) - 1 : 0;
                                gotoPage(page);
                            }}
                            style={{ width: '50px', textAlign: "center" }}
                        />
                    </div>
                </div>

            </div>
        </>
    );
}

export default Table;
